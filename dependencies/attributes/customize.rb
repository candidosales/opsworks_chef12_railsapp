###
# This is the place to override the dependencies cookbook's default attributes.
#
# Do not edit THIS file directly. Instead, create
# "dependencies/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
###

# The following shows how to override the gem binary:
#
#normal[:dependencies][:gem_binary] = '/my/gem/binary'

normal[:dependencies][:gem_binary] = "/usr/local/bin/gem"
