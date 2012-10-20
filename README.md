USB Device List
===
(Mac only atm)
 
Setup
===
- Install [Redis](http://redis.io/download)
- Run `bundle install`


Running the site
===

- Run `padrino start`
- Go to `http://localhost:3000` to see the list as a web page
- You can also get JSON output at `http://localhost:3000/devices`


Notes
===

- Run `rake list` and list of USB devices will be output to JSON file
- Use `config.yml` to blacklist certain devices (such as USB Hub, camera etc.)
- Set `redis: false` in `config.yml` to disable Redi script if you don't have it setup.