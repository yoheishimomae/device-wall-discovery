require 'rubygems'
require 'json'
require 'yaml'
require 'sequel'


class DeviceWallDiscovery 
  
  
  attr_accessor :config, :db
  
  
  private
  
  
  def initialize( path = nil)
    @config = YAML.load( File.read( 'config.yml' ) )
    if path
      @config["json_path"] = path
    end
    initialize_database
  end
  
  
  def initialize_database
    @db = Sequel.sqlite "devices.db"
    if !@db.table_exists?(:devices) 
      puts 'Creating table :devices'
      @db.create_table :devices do
        primary_key :id
        String :name
        String :metadata
        String :serial
        Boolean :is_connected
      end
    end
  end
  
  
  def parse_device_output( content )
    
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
    
    JSON.parse( content )
    
  end
  
  
  def update_device_record
    devices = @db[:devices]
    devices.update( :is_connected => false )
    connected_devices = get_connected_devices

    # check for any new devices
    connected_devices.each do |d1|
      is_new = true
      devices.each do |d2|
        if d1["SerialNumber"] == d2[:serial]
          is_new = false
          devices.where( :serial => d2[:serial] ).update( :is_connected => true, :metadata => d1.to_json )
          break
        end
      end

      if is_new
        puts 'New device detected'
        devices.insert( :name => d1["Title"], 
                        :metadata => d1.to_json, 
                        :serial => d1["SerialNumber"],
                        :is_connected => true)
      end
    end
  end
  
  
  public
  
  
  def get_connected_devices
    temp_path = 'temp'
    devices = []

    # Mac only, for Linux use lsusb (some mod needed probably)
    system 'system_profiler SPUSBDataType | tee ' + temp_path
    usb_devices = parse_device_output( File.read( temp_path ) )
    File.delete( temp_path )
    
    # check if any of the devices are blacklisted
    usb_devices.each do |d|
      pass = true
      title = d["Title"]
      @config["blacklist"].each do |t|
        search = title.scan( /#{t}/ )
        if search.length > 0
          pass = false
          break
        end
      end
      if pass 
        devices.push( d )
      end
    end
    return devices
  end
  
  
  def get_inventory 
    
    update_device_record
    
    devices = @db[:devices]
    connected_count = devices.where(:is_connected => true).count
    new_list = []

    devices.each do |d|
      d[:metadata] = JSON.parse( d[:metadata] )
      new_list.push( JSON.parse( d.to_json ) )
    end

    json = JSON.pretty_generate( {  :count => connected_count, 
                                    :full_count => devices.count, 
                                    :devices => new_list } )

    file = File.new( config['json_path'], "w" )
    file.write( json )
    file.close
    
    return json
  end
  
  
end