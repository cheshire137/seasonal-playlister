# encoding=utf-8
require 'sinatra'
require 'logger'
require 'json'
require 'omniauth'
require 'digest'
require 'open-uri'
require 'nokogiri'
require_relative 'backend/google_playlist'

LASTFM_API_URL = 'http://ws.audioscrobbler.com/2.0/'

enable :sessions, :logging
set :session_secret, ENV['SESSION_KEY']

before do
  logger.level = Logger::DEBUG
end

if ENV['RACK_ENV'] == 'production'
  set :public_folder, 'dist'
  set :assets_folder, 'dist'
  set :bower_root, 'dist'
else
  set :public_folder, 'app'
  set :assets_folder, '.tmp'
  set :bower_root, File.dirname(__FILE__)
end

def strip_smart_quotes str
  str.gsub(/[‘’]/, "'").gsub(/[”“]/, '"')
end

use Rack::Static, urls: ['/styles', '/scripts/controllers', '/scripts/services',
                         '/scripts/models'], root: settings.assets_folder
use Rack::Static, urls: ['/views', '/images'], root: settings.public_folder
use Rack::Static, urls: ['/bower_components'], root: settings.bower_root

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/config.json' do
  content_type 'application/json'
  {lastfm_api_key: ENV['LASTFM_API_KEY']}.to_json
end

get '/scripts/app.js' do
  send_file File.join(settings.public_folder, 'scripts', 'app.js')
end

get '/scripts/routes.js' do
  send_file File.join(settings.public_folder, 'scripts', 'routes.js')
end

get '/lastfm_auth' do
  token = params[:token]
  query_params = {api_key: ENV['LASTFM_API_KEY'],
                  method: 'auth.getsession',
                  token: token}
  signature = query_params.map {|k, v| "#{k}#{v}" }.join('') +
              ENV['LASTFM_API_SECRET']
  signature = Digest::MD5.hexdigest(signature)
  # See http://www.last.fm/api/show/auth.getSession
  url = "#{LASTFM_API_URL}?" +
        query_params.map {|k, v| "#{k}=#{v}" }.join('&') +
        "&api_sig=#{signature}"
  lastfm_session_xml = open(url).read
  doc = Nokogiri::XML(lastfm_session_xml)
  lastfm_user = doc.at_xpath('//lfm//session//name').content
  lastfm_session_key = doc.at_xpath('//lfm//session//key').content
  session[:lastfm_user] = lastfm_user
  session[:lastfm_session_key] = lastfm_session_key
  redirect "/index.html#/lastfm_auth/#{lastfm_user}"
end

post '/google/playlist' do
  content_type :json
  playlist = GooglePlaylist.new(params)
  response = playlist.set_cookie
  if response.is_a?(Net::HTTPSuccess)
    response = playlist.create
  end
  status response.code
  response.body.to_json
end

get '/auth/:name/callback' do
  # See https://github.com/nixme/omniauth-rdio for description of object
  auth = request.env['omniauth.auth']
  session[:rdio_user] = auth['info']['name']
  session[:rdio_access_token] = auth['credentials']['token']
  session[:rdio_access_secret] = auth['credentials']['secret']
  user_for_url = URI.escape(session[:rdio_user],
                            Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  redirect "/index.html#/rdio/#{user_for_url}"
end

get '/auth/failure' do
  message = URI.escape(params[:message],
                       Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  strategy = params[:rdio]
  redirect "/index.html#/auth/failure/#{strategy}/#{message}"
end
