#
# Cookbook Name:: cb-tomcat
# Recipe:: default
#

# Configure Java
include_recipe 'cb-java::default'

# Configure Tomcat
include_recipe 'cb-tomcat::tomcat'
