require 'dotenv'
Dotenv.load('env.sh')

require './app'
run Sinatra::Application
