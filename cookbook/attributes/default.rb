
# Basic installation
node.default['tomcat']['user'] = 'tomcat'
node.default['tomcat']['group'] = 'tomcat'
node.default['tomcat']['version'] = '7.0.54'
node.default['tomcat']['install_directory'] = '/opt'
node.default['tomcat']['java_opts'] = [
  '-Djava.awt.headless=true',
  '-Dfile.encoding=UTF-8',
  '-server'
]
node.default['tomcat']['catalina_opts'] = [
]

# Manager
node.default['tomcat']['webapps']['manager']['deploy'] = true
node.default['tomcat']['webapps']['manager']['admin-script']['enabled'] = true
node.default['tomcat']['webapps']['manager']['admin-script']['pw'] = 'script'
node.default['tomcat']['webapps']['manager']['admin-gui']['enabled'] = true
node.default['tomcat']['webapps']['manager']['admin-gui']['pw'] = 'gui'

# JMX
default['tomcat']['jmx']['rmi_registry_port'] = '10001'
default['tomcat']['jmx']['rmi_server_port'] = '10002'
default['tomcat']['jmx']['rmi_bind_address'] = 'localhost'
default['tomcat']['jmx']['use_local_ports'] = false
default['tomcat']['jmx']['ssl'] = false
default['tomcat']['jmx']['authenticate'] = true
default['tomcat']['jmx']['password_file'] =
  '$CATALINA_HOME/conf/jmxremote.password'
default['tomcat']['jmx']['access_file'] =
  '$CATALINA_HOME/conf/jmxremote.access'
default['tomcat']['jmx']['username'] = 'admin-jmx'
default['tomcat']['jmx']['password'] = 'jmx'

# JDWP
default['tomcat']['jdwp']['enabled'] = true
default['tomcat']['jdwp']['suspend'] = false
default['tomcat']['jdwp']['port'] = '10003'

# server.xml
default['tomcat']['shutdown_port'] = '8005'
default['tomcat']['shutdown'] = 'shutdown'
default['tomcat']['executor']['max_threads'] = '100'
default['tomcat']['executor']['min_spare_threads'] = '10'
default['tomcat']['connector']['http']['protocol'] =
  'org.apache.coyote.http11.Http11NioProtocol'
default['tomcat']['connector']['http']['port'] = '8080'
default['tomcat']['connector']['http']['redirect_port'] = '8443'
default['tomcat']['connector']['http']['connection_timeout'] = '20000'
default['tomcat']['connector']['http']['uri_encoding'] = 'UTF-8'
