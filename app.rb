# encoding=utf-8
require 'sinatra'
require 'logger'
require 'json'
require 'omniauth'
require 'omniauth-rdio'
require 'rdio'
require_relative 'backend/google_playlist'

RDIO_API_KEY = ENV['RDIO_API_KEY']
RDIO_API_SHARED_SECRET = ENV['RDIO_API_SHARED_SECRET']

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

def get_rdio_client session
  client = Rdio::Client.new(RDIO_API_KEY, RDIO_API_SHARED_SECRET)
  if session[:rdio_access_token] && session[:rdio_access_secret]
    client.access_token = session[:rdio_access_token]
    client.secret = session[:rdio_access_secret]
  end
  client
end

def strip_smart_quotes str
  str.gsub(/[‘’]/, "'").gsub(/[”“]/, '"')
end

use OmniAuth::Builder do
  provider :rdio, RDIO_API_KEY, RDIO_API_SHARED_SECRET
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

get '/logout/rdio' do
  session[:rdio_user] = nil
  session[:rdio_access_token] = nil
  session[:rdio_access_secret] = nil
  redirect '/index.html#/logged-out/rdio'
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

get '/rdio/search/artist' do
  content_type :json
  client = get_rdio_client(session)
  query = strip_smart_quotes(params[:query])
  artists = client.search(query, 'Artist')
  if artists.count > 0
    artist = artists[0]
    {id: artist.key, name: artist.name}.to_json
  else
    {id: nil, error: "Could not find artist '#{query}' on Rdio."}.to_json
  end
end

get '/rdio/search/track' do
  content_type :json
  client = get_rdio_client(session)
  query = strip_smart_quotes(params[:query])
  artist_id = params[:artist_id]
  tracks = client.getTracksForArtist(artist: artist_id, query: query)
  if tracks.count > 0
    track = tracks[0]
    {id: track.key}.to_json
  else
    {id: nil, error: "Could not find track '#{query}' on Rdio."}.to_json
  end
end

post '/rdio/playlist' do
  content_type :json
  json_params = JSON.parse(request.body.read)
  name = json_params['name']
  description = json_params['description']
  tracks = json_params['tracks']
  client = get_rdio_client(session)
  playlist = client.createPlaylist(name: name, description: description,
                                   tracks: tracks)
  {name: playlist.name, song_count: playlist.length, image_url: playlist.icon,
   id: playlist.key, url: playlist.shortUrl}.to_json
end
