
# Basic installation
node.default['tomcat']['user'] = 'tomcat'
node.default['tomcat']['group'] = 'tomcat'
node.default['tomcat']['version'] = '7.0.54'
node.default['tomcat']['install_directory'] = '/opt'
node.default['tomcat']['java_opts'] = [
  '-Djava.awt.headless=true',
  '-Dfile.encoding=UTF-8',
  '-server',
  '-XX:-HeapDumpOnOutOfMemoryError',
  '-XX:-OmitStackTraceInFastThrow',
  '-Djava.net.preferIPv4Stack=true'
]
node.default['tomcat']['catalina_opts'] = [
]

# APR
node.default['tomcat']['apr']['version'] = '1.5.1'
node.default['tomcat']['apr-util']['version'] = '1.5.3'
node.default['tomcat']['apr']['install_directory'] = '/usr/local'

# Manager
node.default['tomcat']['webapps']['manager']['deploy'] = true
node.default['tomcat']['webapps']['manager']['admin-script']['enabled'] = true
node.default['tomcat']['webapps']['manager']['admin-script']['pw'] = 'script'
node.default['tomcat']['webapps']['manager']['admin-gui']['enabled'] = true
node.default['tomcat']['webapps']['manager']['admin-gui']['pw'] = 'gui'

# JMX
node.default['tomcat']['jmx']['rmi_registry_port'] = '10001'
node.default['tomcat']['jmx']['rmi_server_port'] = '10002'
node.default['tomcat']['jmx']['rmi_bind_address'] = 'localhost'

# JDWP
node.default['tomcat']['jdwp']['enabled'] = true
node.default['tomcat']['jdwp']['suspend'] = false
node.default['tomcat']['jdwp']['port'] = '10003'

# server.xml
# Connector options from: http://tomcat.apache.org/tomcat-7.0-doc/config/http.html
node.default['tomcat']['shutdown_port'] = '8005'
node.default['tomcat']['shutdown'] = 'shutdown'
node.default['tomcat']['executor']['max_threads'] = '100'
node.default['tomcat']['executor']['min_spare_threads'] = '10'
node.default['tomcat']['connector']['apr']['enabled'] = true
node.default['tomcat']['connector']['ssl_engine'] = 'off'
node.default['tomcat']['connector']['http']['allow_trace'] = 'false'
node.default['tomcat']['connector']['http']['async_timeout'] = '10000'
node.default['tomcat']['connector']['http']['enable_lookups'] = 'false'
node.default['tomcat']['connector']['http']['max_header_count'] = '100'
node.default['tomcat']['connector']['http']['max_parameter_count'] = '10000'
node.default['tomcat']['connector']['http']['max_post_size'] = '2097152'
node.default['tomcat']['connector']['http']['max_save_post_size'] = '4096'
node.default['tomcat']['connector']['http']['parse_body_methods'] = 'POST'
node.default['tomcat']['connector']['http']['port'] = '8080'
node.default['tomcat']['connector']['http']['protocol'] =
  'org.apache.coyote.http11.Http11AprProtocol'
node.default['tomcat']['connector']['http']['proxy_name'] = ''
node.default['tomcat']['connector']['http']['proxy_port'] =
  node['tomcat']['connector']['http']['port']
node.default['tomcat']['connector']['http']['redirect_port'] = '8443'
node.default['tomcat']['connector']['http']['scheme'] = 'http'
node.default['tomcat']['connector']['http']['secure'] = 'false'
node.default['tomcat']['connector']['http']['uri_encoding'] = 'UTF-8'
node.default['tomcat']['connector']['http']['body_encoding_for_uri'] = 'false'
node.default['tomcat']['connector']['http']['use_ipv_hosts'] = 'false'
node.default['tomcat']['connector']['http']['xpoweredby'] = 'false'
node.default['tomcat']['connector']['http']['accept_count'] = '100'
node.default['tomcat']['connector']['http']['acceptor_thread_count'] = '2'
node.default['tomcat']['connector']['http']['acceptor_thread_priority'] = '5'
node.default['tomcat']['connector']['http']['address'] = ''
node.default['tomcat']['connector']['http']['bind_on_init'] = 'true'
node.default['tomcat']['connector']['http']['compressable_mime_type'] = ''
node.default['tomcat']['connector']['http']['compression'] = 'off'
node.default['tomcat']['connector']['http']['compression_min_size'] = '2048'
node.default['tomcat']['connector']['http']['connection_linger'] = '-1'
node.default['tomcat']['connector']['http']['connection_timeout'] = '20000'
node.default['tomcat']['connector']['http']['connection_upload_timeout'] =
  '300000'
node.default['tomcat']['connector']['http']['disable_upload_timeout'] = 'true'
node.default['tomcat']['connector']['http']['executor'] = 'tomcatThreadPool'
node.default['tomcat']['connector']['http']['executor_kill_timeout'] = ''
node.default['tomcat']['connector']['http']['keep_alive_timeout'] = '5000'
node.default['tomcat']['connector']['http']['max_connections'] = ''
node.default['tomcat']['connector']['http']['max_extension_size'] = '8192'
node.default['tomcat']['connector']['http']['max_http_header_size'] = '8192'
node.default['tomcat']['connector']['http']['max_keep_alive_requests'] = '1'
node.default['tomcat']['connector']['http']['max_threads'] = '200'
node.default['tomcat']['connector']['http']['max_trailer_size'] = '8192'
node.default['tomcat']['connector']['http']['min_spare_threads'] = ''
node.default['tomcat']['connector']['http']['no_compression_user_agents'] = ''
node.default['tomcat']['connector']['http']['processor_cache'] = '200'
node.default['tomcat']['connector']['http']['restricted_user_agents'] = ''
node.default['tomcat']['connector']['http']['server'] = 'server'
node.default['tomcat']['connector']['http']['socket_buffer'] = '9000'
node.default['tomcat']['connector']['http']['ssl_enabled'] = 'false'
node.default['tomcat']['connector']['http']['tcp_no_delay'] = 'true'
node.default['tomcat']['connector']['http']['thread_priority'] = '5'
node.default['tomcat']['connector']['http']['defer_accept'] = 'true'
node.default['tomcat']['connector']['http']['poller_size'] = '8192'
node.default['tomcat']['connector']['http']['poll_time'] = '2000'
node.default['tomcat']['connector']['http']['sendfile_size'] = '1024'
node.default['tomcat']['connector']['http']['thread_priority'] = '5'
node.default['tomcat']['connector']['http']['use_comet'] = 'false'
node.default['tomcat']['connector']['http']['use_sendfile'] = 'false'
