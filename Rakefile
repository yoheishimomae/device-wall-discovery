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

# All this does is parse the database info into json

task :inventory do
  require 'json'
  require 'yaml'
  require 'sequel'
  
  Rake::Task[:update_db].execute
  
  config = YAML.load( File.read( 'config.yml' ) )
  fileout = config['list_path']
  
  db = Sequel.sqlite "devices.db"
  devices = db[:devices]
  connected_count = devices.where(:is_connected => true).count
  new_list = []
  
  devices.each do |d|
    d[:metadata] = JSON.parse( d[:metadata] )
    new_list.push( JSON.parse( d.to_json ) )
  end
  
  json = JSON.pretty_generate( { :count => connected_count, :full_count => devices.count, :devices => new_list } )
  
  file = File.new( config['inventory_path'], "w" )
  file.write( json )
  file.close
  
  puts "Done! - #{fileout}"
end


# Database related

task :initialize_db do
  require "sequel"
  
  db = Sequel.sqlite "devices.db"
  
  if !db.table_exists?(:devices) 
    puts 'Creating table :devices'
    db.create_table :devices do
      primary_key :id
      String :name
      String :metadata
      String :owner
      String :serial
      Boolean :is_connected
    end
  end
end


task :update_db do
  require 'json'
  require 'yaml'
  require 'sequel'
  
  Rake::Task[:list].execute
  Rake::Task[:initialize_db].execute
  
  config = YAML.load( File.read( 'config.yml' ) )
  fileout = config['list_path']
  
  # check for any new devices
  db = Sequel.sqlite "devices.db"
  devices = db[:devices]
  devices.update(:is_connected => false)
  
  connected = JSON.parse( File.read( fileout ) )["devices"]
  connected.each do |d1|
    is_new = true
    devices.each do |d2|
      if d1["SerialNumber"] == d2[:serial]
        is_new = false
        devices.where(:serial => d2[:serial]).update(:is_connected => true)
        break
      end
    end
    
    if is_new
      puts 'New device detected'
      devices.insert( 
        :name => d1["Title"], 
        :metadata => d1.to_json, 
        :serial => d1["SerialNumber"],
        :is_connected => true)
    end
  end
  
  puts "Database updated"
end
