USB Device List
===
(Mac only atm)
 
- Run `bundle install`
- Run `rake list` and list of USB devices will be output to JSON file


Running the site
===

- Run `padrino start`
- Go to `http://localhost:3000` to see the list as a web page
- You can also get JSON output at `http://localhost:3000/devices`


Notes
===

Use `config.yml` to blacklist certain devices (such as USB Hub, camera etc.)