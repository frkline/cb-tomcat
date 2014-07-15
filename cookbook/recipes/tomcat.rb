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

# Undeploy default webapps
webapps_undeploy = [
  "#{node['tomcat']['install_directory']}/tomcat/webapps/docs",
  "#{node['tomcat']['install_directory']}/tomcat/webapps/examples"
]
if node['tomcat']['webapps']['manager']['deploy'] == false
  webapps_undeploy = webapps_undeploy.concat([
    "#{node['tomcat']['install_directory']}/tomcat/webapps/manager",
    "#{node['tomcat']['install_directory']}/tomcat/webapps/host-manager"
  ])
end
webapps_undeploy.each do |dir|
  directory dir do
    recursive true
    action :delete
  end
end

# Add the version file
template "#{node['tomcat']['install_directory']}/tomcat/VERSION" do
  source 'VERSION.erb'
  mode '755'
  notifies :restart, 'service[tomcat]', :delayed
end

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

# Tomcat users configuration
tomcat_users_file = 
  "#{node['tomcat']['install_directory']}/tomcat/"\
  'conf/tomcat-users.xml'
template tomcat_users_file do
  source 'tomcat-users.xml.erb'
  mode '755'
  notifies :restart, 'service[tomcat]', :delayed
end

# Start the tomcat service
service 'tomcat' do
  supports :restart => true, :start => true, :stop => true
  action [:enable]
end
