# cron_jobs

##Usage

     "cron_jobs": {
        "app_name": [
            {
                name: "myjob",
                hour: "2",
                command: "cd /srv/www/myapp/current && bundle exec my_command",
                path: "/usr/local/bin:$PATH"
            }
        ]
    }
