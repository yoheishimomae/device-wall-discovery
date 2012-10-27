require 'rubygems'
require 'sinatra'
require 'json'
require 'less'

set :public_folder, File.dirname(__FILE__) + '/public'

config = YAML.load( File.read( 'config.yml' ) )

get '/css/:app.css' do
  less( File.read( File.dirname(__FILE__) + '/stylesheets/app.less') )
end

get "/" do
  erb :inventory
end

get "/list" do
  erb :list
end

get "/devices" do
  system 'bundle exec rake list'
  list = JSON.parse( File.read( config['list_path'] ) )    
  return JSON.pretty_generate( list )
end

get "/inventory" do
  system 'bundle exec rake inventory'
  list = JSON.parse( File.read( config['inventory_path'] ) )    
  return JSON.pretty_generate( list )
end