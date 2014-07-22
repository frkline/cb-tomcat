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
    '-Dcom.sun.management.jmxremote=',
    '-Djava.rmi.server.hostname'\
      "=#{node['tomcat']['jmx']['rmi_bind_address']}",
    '-Dcom.sun.management.jmxremote.ssl=false',
    '-Dcom.sun.management.jmxremote.ssl=false',
    '-Dcom.sun.management.jmxremote.authenticate=false'
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

# Enable the tomcat service
service 'tomcat' do
  supports :restart => true, :start => true, :stop => true
  action [:enable]
end

# Install APR
bash 'reload profile prior to apr installation' do
  code 'source /etc/profile'
end
apr_download_url =
  'http://archive.apache.org/dist/apr/'\
  "apr-#{node['tomcat']['apr']['version']}.tar.gz"
apr_util_download_url =
  'http://archive.apache.org/dist/apr/'\
  "apr-util-#{node['tomcat']['apr-util']['version']}.tar.gz"
ark 'apr' do
  url apr_download_url
  checksum '94b1c9d9835cc9e902838b95d62ecc9a39b698f23e3e706812ec65a78ba41af7'
  version node['tomcat']['apr']['version']
  prefix_root node['tomcat']['apr']['install_directory']
  prefix_home node['tomcat']['apr']['install_directory']
  owner 'root'
  action :configure
end
bash 'make apr' do
  user 'root'
  cwd node['tomcat']['apr']['install_directory']
  code <<-EOH
  cd apr-#{node['tomcat']['apr']['version']}
  make && make install
  EOH
end
ark 'apr-util' do
  url apr_util_download_url
  checksum '76db34cb508e346e3bf69347c29ed1500bf0b71bcc48d54271ad9d1c25703743'
  version node['tomcat']['apr-util']['version']
  prefix_root node['tomcat']['apr']['install_directory']
  prefix_home node['tomcat']['apr']['install_directory']
  autoconf_opts ['--with-apr=/usr/local/apr/']
  owner 'root'
  action :configure
end
ark 'tomcat-native' do
  url "file://#{node['tomcat']['install_directory']}/"\
      'tomcat/bin/tomcat-native.tar.gz'
  version node['tomcat']['version']
  prefix_root node['tomcat']['apr']['install_directory']
  prefix_home node['tomcat']['apr']['install_directory']
  strip_components 3
  autoconf_opts ['--with-apr=/usr/local/apr/']
  owner 'root'
  action :configure
end
bash 'make apr utils and tomcat native' do
  user 'root'
  cwd node['tomcat']['apr']['install_directory']
  code <<-EOH
  cd apr-util-#{node['tomcat']['apr-util']['version']}
  make && make install
  cd #{node['tomcat']['apr']['install_directory']}
  cd tomcat-native-#{node['tomcat']['version']}
  make && make install
  EOH
end
template '/etc/profile.d/apr.sh' do
  source 'apr.sh.erb'
  mode '755'
  notifies :restart, 'service[tomcat]', :delayed
end
bash 'reload profile' do
  code 'source /etc/profile'
end

# Enable logback logging via slf4j
# Note that these jars are linked into the classpath by template catalina.sh.erb
# http://hwellmann.blogspot.com/2012/11/logging-with-slf4j-and-logback-in.html
cookbook_file 'logging.properties' do
  path "#{node['tomcat']['install_directory']}/tomcat/conf/logging.properties"
  action :create
  notifies :restart, 'service[tomcat]', :delayed
end
ark 'slf4j-api' do
  url 'http://www.slf4j.org/dist/slf4j-1.7.7.zip'
  creates 'slf4j-api-1.7.7.jar'
  path "#{node['tomcat']['install_directory']}/tomcat/bin"
  action :cherry_pick
end
ark 'jul-to-slf4j' do
  url 'http://www.slf4j.org/dist/slf4j-1.7.7.zip'
  creates 'jul-to-slf4j-1.7.7.jar'
  path "#{node['tomcat']['install_directory']}/tomcat/bin"
  action :cherry_pick
end
ark 'logback-classic' do
  url 'http://logback.qos.ch/dist/logback-1.1.2.zip'
  creates 'logback-classic-1.1.2.jar'
  path "#{node['tomcat']['install_directory']}/tomcat/bin"
  action :cherry_pick
end
ark 'logback-core' do
  url 'http://logback.qos.ch/dist/logback-1.1.2.zip'
  creates 'logback-core-1.1.2.jar'
  path "#{node['tomcat']['install_directory']}/tomcat/bin"
  action :cherry_pick
end
directory "#{node['tomcat']['install_directory']}/tomcat/bin/log" do
  mode '755'
  action :create
end
template "#{node['tomcat']['install_directory']}/tomcat/bin/log/logback.xml" do
  source 'logback.xml.erb'
  mode '644'
  notifies :restart, 'service[tomcat]', :delayed
end
