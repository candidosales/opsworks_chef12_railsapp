default['le']['logs_to_follow'] = [
    {name: 'syslog', log: '/var/log/syslog'},
    {name: 'varlog', log: '/var/log/*.log'}
]

layer = search('aws_opsworks_layer').first
app = search('aws_opsworks_app').first

if !!layer['shortname'] =~ /rails-app/
  default['le']['logs_to_follow'] << {name: layer['shortname'], log: "/srv/www/#{app['shortname']}/shared/log/production.log"}
end


if layer['shortname'] == 'sidekiq'
  default['le']['logs_to_follow'] << {name: 'sidekiq-log', log: "/srv/www/#{app['shortname']}/shared/log/sidekiq.log"}
  default['le']['logs_to_follow'] << {name: 'sidekiq-dblog', log: "/srv/www/#{app['shortname']}/shared/log/production.log"}
end

if layer['shortname'] == 'mq'
  default['le']['logs_to_follow'] << {name: 'message-queue-log', log: "/srv/www/#{app['shortname']}/shared/log/sneakers.log"}
  default['le']['logs_to_follow'] << {name: 'message-queue-dblog', log: "/srv/www/#{app['shortname']}/shared/log/production.log"}
end
