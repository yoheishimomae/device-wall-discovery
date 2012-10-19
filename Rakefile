task :list do 
  require 'json'
  require 'yaml'
  
  fileout = 'usb_list.json'
  config = YAML.load( File.read( 'config.yml' ) )
  devices = []
  
  # Mac only, for Linux use lsusb (some mod needed proably)
  system 'system_profiler SPUSBDataType | tee ' + fileout
  
  content = File.read( fileout )
  
  # Format device titles
  content.gsub!( /\n\s+[^:]+:\n/ ) {|m|  
    m.gsub!( /:/, '"' )
    m.gsub!( /\n\s+/, '},{"Title":"' )
  }
  
  # Format device properties
  content.gsub!( /\n\s+[^:]+:[^\n}]+/ ) {|m|  
    m.gsub!( /\n\s+/, ',"' )
    m.gsub!( /:/, '":"' )
    m.gsub!( /[^:]+:/ ) {|m2| m2.gsub( /\s/, "" ) } # Removes space cahrs out of property key
    m += '"'
  }
  
  # Format and parse
  content.gsub!( /USB:}\,/, "" )
  content = "[#{content}}]"
  usb_list = JSON.parse( content )
  
  # check if any of the devices are blacklisted
  usb_list.each do |d|
    pass = true
    title = d["Title"]
    
    config["blacklist"].each do |t|
      search = title.scan(/#{t}/)
      if search.length > 0
        pass = false
        break
      end
    end
    
    if pass 
      devices.push( d )
    end
    
  end
  
  list = { :count => devices.length, :list => devices }
  
  file = File.new( fileout, "w" )
  file.write( JSON.pretty_generate( list ) )
  file.close
  
  
  puts "Done! - #{fileout}"
end