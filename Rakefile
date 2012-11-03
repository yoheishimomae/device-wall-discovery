task :inventory, :path do |t, args|
  require 'discovery'
  discovery = DeviceWallDiscovery.new( args[:path] )
  discovery.get_inventory
end

task :extend, :path do |t, args|
  require 'discovery'
  discovery = DeviceWallDiscovery.new( args[:path] )
  discovery.get_extended_inventory
end
