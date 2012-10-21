Device Wall
===
Keeps track of devices that are connected to USB hubs. Useful for device inventory.

 
Setup
===
- Install [Redis](http://redis.io/download)
- Run `bundle install`


Running the site
===

- Run `rake server`
- Go to `http://localhost:3000` or `http://localhost:3000/list` to see the list as a web page
- You can also get JSON output at `http://localhost:3000/devices` and `http://localhost:3000/inventory`


Notes
===

- If you want to get just the JSON output without running Sinatra, you can run `rake list` and `rake inventory` which will save .json files in public. To run `rake inventory`, you will need to have a Redis server running.
- Use `config.yml` to blacklist certain devices (such as USB Hub, camera etc.)