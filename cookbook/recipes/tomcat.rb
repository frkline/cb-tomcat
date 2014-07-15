#
# Cookbook Name:: cb-tomcat
# Recipe:: tomcat
#

# Create tomcat group
group node['tomcat']['group']

# Create tomcat user
user node['tomcat']['user'] do
  supports :manage_home => true
  group node['tomcat']['group']
  system true
  home '/home/tomcat'
  shell '/bin/bash'
  comment 'Tomcat user'
end

# Download and unpack tomcat
download_url =
  'http://archive.apache.org/dist/tomcat/tomcat-7/'\
  "v#{node['tomcat']['version']}/bin/apache-tomcat-"\
  "#{node['tomcat']['version']}.tar.gz"
extras_download_url =
  'http://archive.apache.org/dist/tomcat/tomcat-7/'\
  "v#{node['tomcat']['version']}/bin/extras"
ark 'tomcat' do
  url download_url
  checksum 'f0316c128881c4df384771dc0da8f8e80d861385798e57d22fd4068f48ab8724'
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
  mode '644'
  notifies :restart, 'service[tomcat]', :delayed
end

# Download an add JmxRemoteLifecycleListener
# http://tomcat.apache.org/tomcat-7.0-doc/config/listeners.html
jmx_remote_jar =
  "#{node['tomcat']['install_directory']}/tomcat/"\
  'lib/catalina-jmx-remote.jar'
remote_file jmx_remote_jar do
  source "#{extras_download_url}/catalina-jmx-remote.jar"
  mode '644'
  notifies :restart, 'service[tomcat]', :delayed
end

# Update CATALINA_OPTS
node.normal['tomcat']['catalina_opts'] =
  node['tomcat']['catalina_opts'].concat([
    '-Dcom.sun.management.jmxremote.ssl'\
      "=#{node['tomcat']['jmx']['ssl']}",
    '-Dcom.sun.management.jmxremote.authenticate'\
      "=#{node['tomcat']['jmx']['authenticate']}",
    '-Dcom.sun.management.jmxremote.password.file'\
      "=#{node['tomcat']['jmx']['password_file']}",
    '-Dcom.sun.management.jmxremote.access.file'\
      "=#{node['tomcat']['jmx']['access_file']}"
  ])

# Enable JDWP
# http://docs.oracle.com/javase/1.5.0/docs/guide/jpda/jdwp-spec.html
if node['tomcat']['jdwp']['enabled']
  if node['tomcat']['jdwp']['suspend']
    node.normal['tomcat']['catalina_opts'] =
      node['tomcat']['catalina_opts'].concat([
        '-Xdebug',
        '-Xrunjdwp:transport=dt_socket,address='\
          "#{node['tomcat']['jdwp']['port']},suspend=y,server=y"
      ])
  else
    node.normal['tomcat']['catalina_opts'] =
      node['tomcat']['catalina_opts'].concat([
        '-Xdebug',
        '-Xrunjdwp:transport=dt_socket,address='\
          "#{node['tomcat']['jdwp']['port']},suspend=n,server=y"
      ])
  end
end

# Enable the tomcat service
template '/etc/init.d/tomcat' do
  source 'tomcat.erb'
  mode '755'
  notifies :restart, 'service[tomcat]', :delayed
end

# Tomcat catalina configuration
template "#{node['tomcat']['install_directory']}/tomcat/bin/catalina.sh" do
  source 'catalina.sh.erb'
  mode '755'
  notifies :restart, 'service[tomcat]', :delayed
end

# Tomcat users configuration
tomcat_users_file =
  "#{node['tomcat']['install_directory']}/tomcat/"\
  'conf/tomcat-users.xml'
template tomcat_users_file do
  source 'tomcat-users.xml.erb'
  mode '644'
  notifies :restart, 'service[tomcat]', :delayed
end

# server.xml
template "#{node['tomcat']['install_directory']}/tomcat/conf/server.xml" do
  source 'server.xml.erb'
  mode '644'
  notifies :restart, 'service[tomcat]', :delayed
end

# JMX
password_file =
  "#{node['tomcat']['install_directory']}/tomcat/conf/jmxremote.password"
access_file =
  "#{node['tomcat']['install_directory']}/tomcat/conf/jmxremote.access"
template password_file do
  source 'jmxremote.password.erb'
  mode '644'
  notifies :restart, 'service[tomcat]', :delayed
end
template access_file do
  source 'jmxremote.access.erb'
  mode '644'
  notifies :restart, 'service[tomcat]', :delayed
end

# Enable the tomcat service
service 'tomcat' do
  supports :restart => true, :start => true, :stop => true
  action [:enable]
end
