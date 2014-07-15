#
# Cookbook Name:: cb-tomcat
# Recipe:: tomcat
#

# Create tomcat group
group node['tomcat']['group']

# Create tomcat user
user node['tomcat']['user'] do
  group node['tomcat']['group']
  system true
  shell '/bin/bash'
end

# Download and unpack tomcat
download_url =
  'http://archive.apache.org/dist/tomcat/tomcat-7/'\
  "v#{node['tomcat']['version']}/bin/apache-tomcat-"\
  "#{node['tomcat']['version']}.tar.gz"
ark 'tomcat' do
  url download_url
  version node['tomcat']['version']
  prefix_root node['tomcat']['install_directory']
  prefix_home node['tomcat']['install_directory']
  owner node['tomcat']['user']
end
node.normal['tomcat']['home_directory'] =
  "#{node['tomcat']['install_directory']}/tomcat"

# Enable the tomcat service
template '/etc/init.d/tomcat' do
  source 'init.conf.erb'
  mode '755'
  notifies :restart, 'service[tomcat]', :delayed
end

# Tomcat catalina configuration
template "#{node['tomcat']['install_directory']}/tomcat/bin/catalina.sh" do
  source 'catalina.conf.erb'
  mode '755'
  notifies :restart, 'service[tomcat]', :delayed
end

# Start the tomcat service
service 'tomcat' do
  supports :restart => true, :start => true, :stop => true
  action [:enable]
end
