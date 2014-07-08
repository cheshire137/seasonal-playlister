require 'sinatra'

root_path = File.join(Dir.pwd, 'dist')
set :public_dir, root_path
use Rack::Static, root: root_path

get '/' do
  redirect '/index.html'
end
