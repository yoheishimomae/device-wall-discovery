class FunTest < Padrino::Application
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions
  
  get "/" do
    render 'base/list'
  end
  
  get "/devices" do
    system 'bundle exec rake list'
    usb_list = JSON.parse( File.read( 'public/usb_list.json' ) )
    return JSON.pretty_generate( usb_list )
  end

end
