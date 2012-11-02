Device Wall - Discovery
===

Keeps track of devices that are connected to USB hubs. Useful for device inventory. Also, have a look at [Device Wall - Site](https://github.com/yoheishimomae/device-wall-site)


Setup
===

1. Run `bundle install`
2. Open `config.yml` and set `json_path` where your data will be output (default is `device.json`)
3. Run `rake inventory`
4. Your file will be output to path in step 2

Alternatively, you can specify the output path through rake command such as `rake inventory["/output/path.json"]`. This will override the default path in config. 