# Burst HTTP Cache recipe

## Symlink

    {
      "deploy": {
        "my_app": {
          "symlink_before_migrate": {
              "config/initializers/burst_http_cache.rb": "config/burst_http_cache.rb"
          }
        }
      }
    }

