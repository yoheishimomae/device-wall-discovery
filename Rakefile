task :list do 
  require 'json'
  
  fileout = 'usb_list.json'
  
  # Mac only, for Linux use lsusb (some mod needed proably)
  system 'system_profiler SPUSBDataType | tee ' + fileout
  
  content = File.read( fileout )
  
  # Format device Titles
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
  
  # Format misc
  content.gsub!( /USB:}\,/, "" )
  content = "[#{content}}]"
  
  file = File.new( fileout, "w" )
  file.write( JSON.pretty_generate( JSON.parse( content ) ) )
  file.close
  
  puts 'Done!'  
end