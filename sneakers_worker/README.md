sneakers_worker Cookbook
====================
Configures sneakers_worker to work with monit.

Adapted from delayed_job https://github.com/freerunningtech/frt-opsworks-cookbooks. Thankyou

Requirements
------------

Your Gemfile will require:

```ruby
gem 'sneakers'
gem 'daemons'
```
                               Process control
================================================================================
Stop (nicely) ..............: kill -SIGTERM `cat sneakers.pid`
Stop (immediate) ...........: kill -SIGQUIT `cat sneakers.pid`
Restart (nicely) ...........: kill -SIGUSR1 `cat sneakers.pid`
Restart (immediate) ........: kill -SIGHUP `cat sneakers.pid`
Reconfigure ................: kill -SIGUSR2 `cat sneakers.pid`
Scale workers ..............: reconfigure, then restart
================================================================================


Opsworks Usage
--------------

Simply add the `sneakers_worker::deploy` recipe to your deploy step.

This recipe generates the monit configuration in
`/etc/monit.d/APPLICATION_sneakers_worker.monitrc`, whenever this file changes, any
existing sneakers_worker process is stopped.

On each run `sneakers_worker` is restarted through monit.

Stack Settings
--------------

Delayed Job is configured through stack settings. Here are a few example
configurations.

Two processes running all queues.

```
{
  "deploy": {
    "myapp": {
      "sneakers_worker": [{
        "options": ""
      }],
```

Two processes running jobs of different priorities

```
{
  "deploy": {
    "myapp": {
      "sneakers_worker": [
        {
          "identifier": "normal",
          "options": "--min-priority 0"
        },
        {
          "identifier": "priority",
          "options": "--max-priority -1"
        }
      ]
```


Two processes running jobs in different queues

```
{
  "deploy": {
    "myapp": {
      "sneakers_worker": [
        {
          "options": "--queue=priority"
        },
        {
          "options": "--queues=mail,tasks"
        }
      ]
```

Modified to:

```
{
  "deploy": {
    "myapp": {
      "sneakers_worker": ["Worker1", "Worker2"]
    }
  }
}

```

Remember to symlink

```
{
  "config/sneakers.rb": "config/initializers/sneakers.rb"
}
```
