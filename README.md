opsworks-cookbooks
==================

**This repo contains cookbooks used by AWS OpsWorks for Chef versions 12.**

To get started with AWS OpsWorks cookbooks for all versions of Chef see the [cookbook documentation](https://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook.html).

## Changes from AWS opsworks-cookbook

The following enhancements were added:

1. Support for non-Berkshelf environment
1. Make use of Chef Data bags provided by Opsworks for environment variables, layer and app related settings
1. Use [ruby_build](https://github.com/poise/poise-ruby-build) instead of AWS provided installer for Ruby binaries
  
## Notes
  
1. This stack assumes the usage of Ubuntu 14.04 instances. Any other versions are not extensively tested.
1. This stack supports Rails app on PostgreSQL databases only. Any other stack combinations are not tested.


## Development

1. Clone the repository https://github.com/KernCheh/opsworks-cookbooks
1. Follow the setup instructions on setting up Berkshelf to vendor cookbooks.

## TODO

1. Cleanup unused recipes.
