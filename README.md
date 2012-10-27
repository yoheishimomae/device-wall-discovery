Device Wall
===
Keeps track of devices that are connected to USB hubs. Useful for device inventory.

 
Setup
===
- Run `bundle install`


Running the site
===

- Set `cd` to the project directory and run `rake server`
- Go to `http://localhost:3000`
- You can also get JSON output at `http://localhost:3000/inventory`


Notes
===

- Everyting you hit `/list`, any new device that is connected gets registered to the database
- If you want to get just the JSON output without running Sinatra, you can run `rake list` and `rake inventory` which will save .json files in public.
- Use `config.yml` to blacklist certain devices (such as USB Hub, camera etc.)