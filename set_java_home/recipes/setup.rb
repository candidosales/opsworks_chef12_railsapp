#
# Cookbook Name:: set_java_home
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
if node[:java][:java_home]
  ruby_block "Set JAVA_HOME in /etc/environment" do
    block do
      file = Chef::Util::FileEdit.new("/etc/environment")
      file.insert_line_if_no_match(/^JAVA_HOME=/, "JAVA_HOME=#{node[:java][:java_home]}")
      file.search_file_replace_line(/^JAVA_HOME=/, "JAVA_HOME=#{node[:java][:java_home]}")
      file.write_file
    end
  end
end
