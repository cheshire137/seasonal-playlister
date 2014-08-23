require 'sinatra'
require 'logger'
require 'json'

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

use Rack::Static, urls: ['/styles', '/scripts/controllers', '/scripts/services',
                         '/scripts/models'], root: settings.assets_folder
use Rack::Static, urls: ['/views'], root: settings.public_folder
use Rack::Static, urls: ['/bower_components'], root: settings.bower_root

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/scripts/app.js' do
  send_file File.join(settings.public_folder, 'scripts', 'app.js')
end

get '/scripts/routes.js' do
  send_file File.join(settings.public_folder, 'scripts', 'routes.js')
end

post '/playlist' do
  content_type :json
  {hello: 'world'}.to_json
end
