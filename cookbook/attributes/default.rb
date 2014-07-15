
# Basic installation
node.default['tomcat']['user'] = 'tomcat'
node.default['tomcat']['group'] = 'tomcat'
node.default['tomcat']['version'] = '7.0.54'
node.default['tomcat']['install_directory'] = '/opt'
node.default['tomcat']['default_java_opts'] = [
  '-server',
  '-Djava.awt.headless=true'
]
node.default['tomcat']['additional_java_opts'] = []
node.default['tomcat']['webapps']['manager']['deploy'] = false

## server.xml configuration
# default['tomcat-all']['port'] = '8080'
# default['tomcat-all']['shutdown_port'] = '8005'
# default['tomcat-all']['max_threads'] = '100'
# default['tomcat-all']['min_spare_threads'] = '10'
