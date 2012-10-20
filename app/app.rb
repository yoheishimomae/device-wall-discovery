class FunTest < Padrino::Application
  require 'yaml'

  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions
  
  config = YAML.load( File.read( 'config/list_config.yml' ) )
  
  get "/" do
    render 'base/list'
  end
  
  get "/list" do
    render 'base/inventory'
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

end
