require 'rubygems'
require 'sinatra'
require 'json'

set :public_folder, File.dirname(__FILE__) + '/public'

config = YAML.load( File.read( 'config.yml' ) )

get "/" do
  erb :list
end

get "/list" do
  erb :inventory
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