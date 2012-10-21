task :server do
  system 'bundle exec shotgun -p 3000 app/app.rb'
end

task :list do 
  require 'json'
  require 'yaml'
  
  config = YAML.load( File.read( 'config.yml' ) )
  fileout = config['list_path']
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
  content.gsub!( /USB:\}\,/, "" )
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
  
  list = { :count => devices.length, :devices => devices }
  
  file = File.new( fileout, "w" )
  file.write( JSON.pretty_generate( list ) )
  file.close
  
  puts "Done! - #{fileout}"
end

task :update_db do
  require 'json'
  require 'redis'
  require 'yaml'
  
  Rake::Task[:list].execute
  
  config = YAML.load( File.read( 'config.yml' ) )
  fileout = config['list_path']
  
  # Keeps the record in database
  redis = Redis.new
  list = redis.get('device_list')
  
  devices = JSON.parse( File.read( fileout ) )["devices"]
  
  if list == nil 
    redis.set('device_list', devices.to_json)
  else 
    json_list = JSON.parse( list )
    
    # check for any new devices
    devices.each do |d1|
      is_new = true
      json_list.each do |d2|
        if d1["SerialNumber"] == d2["SerialNumber"]
          is_new = false
          break
        end
      end
      
      if is_new
        puts 'New device detected'
        json_list.push( d1 )
      end
    end
    
    redis.set('device_list', json_list.to_json)
  end
  
  puts "Database updated"
end

task :inventory do
  require 'json'
  require 'redis'
  require 'yaml'
  
  Rake::Task[:update_db].execute
  
  config = YAML.load( File.read( 'config.yml' ) )
  fileout = config['list_path']
  
  redis = Redis.new
  devices = JSON.parse( File.read( fileout ) )["devices"]
  inventory = JSON.parse( redis.get('device_list') )
  
  inventory.each do |d1|
    is_connected = false
    devices.each do |d2|
      if d1["SerialNumber"] == d2["SerialNumber"]
        is_connected = true
        break
      end
    end
    
    d1["Connected"] = is_connected
  end
  
  
  list = { :count => devices.length, :full_count => inventory.length, :devices => inventory }
  
  file = File.new( config['inventory_path'], "w" )
  file.write( JSON.pretty_generate( list ) )
  file.close
  
  puts "Done"
end