#sike site

[![Build Status](https://travis-ci.org/sikeio/sikeio.svg?branch=master)](https://travis-ci.org/sikeio/sikeio)

##How to run this app

+ Copy [config/application.yml.sample](config/application.yml.sample) to `config/application.yml`.

+ bundle install
- rake db:setup
- bower install
- foreman start

# Course Building

Need to install the followings globally:

+ npm install -g marked
+ npm install -g xmd

# Controlling Puma

+ PUMA_CONTROL_PORT: port on which to start a puma control app
  + If present, bind 0.0.0.0:$PUMA_CONTROL_PORT
+ PUMA_CONTROL_TOKEN: a optional string token used to access the puma control

To restart puma:

```
pumactl --control-url tcp://localhost:$PUMA_CONTROL_PORT --control-token $PUMA_CONTROL_TOKEN restart
# or curl "localhost$?token=?$PUMA_CONTROL_TOKEN"
```

Details of pumactl:

```
pumactl -h
Usage: pumactl (-p PID | -P pidfile | -S status_file | -C url -T token | -F config.rb) (halt|restart|phased-restart|start|stats|status|stop|reload-worker-directory)
  -S, --state PATH                 Where the state file to use is
  -Q, --quiet                      Not display messages
  -P, --pidfile PATH               Pid file
  -p, --pid PID                    Pid
  -C, --control-url URL            The bind url to use for the control server
  -T, --control-token TOKEN        The token to use as authentication for the control server
  -F, --config-file PATH           Puma config script
  -H, --help                       Show this message
  -V, --version                    Show version
```
