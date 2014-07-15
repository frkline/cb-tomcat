# cb-tomcat

Configures a Tomcat 7 installation. 

- SCM: https://github.com/frkline/cb-tomcat
- Build: 

Note that Tomcat 7 has been chosen as tools support for Tomcat 8 is currently limited. For instance, the Maven plugin to remote deploy WARs to Tomcat does not currently support Tomcat 8: https://issues.apache.org/jira/browse/MTOMCAT-234.

For more information, visit [cb-tomcat](https://github.com/frkline/cb-tomcat)

## Features

- Installs Tomcat 7
- Configure JMX bind and ephemeral ports, address, and local port enforcement with [JmxRemoteLifecycleListener](http://tomcat.apache.org/tomcat-7.0-doc/config/listeners.html#JMX_Remote_Lifecycle_Listener_-_org.apache.catalina.mbeans.JmxRemoteLifecycleListener)
- Configure [JDWP](http://docs.oracle.com/javase/1.5.0/docs/guide/jpda/jdwp-spec.html) for remote debugging during development
- Configure manager-script role for access to the [Manager Application](http://tomcat.apache.org/tomcat-7.0-doc/manager-howto.html#Configuring_Manager_Application_Access) from the [Maven Tomcat 7 Plugin](http://tomcat.apache.org/maven-plugin-2.0/tomcat7-maven-plugin/)

## Supports

- CentOS 6.5

## Configure

```ruby
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
```

## Usage

Prerequisite: [Configure the Cookbook](#configure-the-cookbook)

**Start a CentOS 6.5 VirtualBox VM**
```
> cd cookbook
> bundle exec vagrant up
```

**Connect to the VM**
```
> cd cookbook
> bundle exec vagrant ssh
```

## Development

0. [Configure Your Environment](https://github.com/frkline/dev-setup/#configure-your-environment)
1. Clone the Repository  

  ```
  > git clone --recursive git@github.com:frkline/cb-tomcat.git
  ```  
   
2. Initialize the Cookbook's Dependencies  

  ```
  > cd cb-common/cookbook  
  > bundle install
  ```

  Note: Upon update of the Gemfile, update the Bundle:
  ```
  > cd cookbook
  > bundle install
  ```  
  
3. Start Guard  

  Guard will test, analyze, and lint the cookbook as changes are made by monitoring
  your local directory for changes. It will run ChefSpec, Foodcritic, Rubocop, and ServerSpec tests
  as required. For more information, see: https://github.com/test-kitchen/guard-kitchen.
  ```
  > cd cookbook
  > bundle exec guard start
  ```
  
### Development Tools

**Run ChefSpec**  
ChefSpec is a unit testing framework for testing Chef cookbooks. ChefSpec makes it easy to write examples and get fast feedback on cookbook changes without the need for virtual machines or cloud servers. For more information, see: https://github.com/sethvargo/chefspec.
```
> cd cookbook
> bundle exec rspec
```

**Run Foodcritic**  
Foodcritic is a lint tool for Opscode Chef cookbooks. Along with the default checks, we include community-standard checks from [Etsy](https://github.com/etsy/foodcritic-rules) as well as [CustomInk](https://github.com/customink-webops/foodcritic-rules) For more information, see: http://acrmp.github.io/foodcritic/.
```
> cd cookbook
> bundle exec foodcritic -I foodcritic/* .
```

**Run RuboCop**  
RuboCop is a static code analyzer, based upon the standard Ruby community style guide. For more information, see: https://github.com/bbatsov/rubocop.
```
> cd cookbook
> bundle exec rubocop
```

**Run Tests with Kitchen**  
Kitchen is an integration tool for developing and testing infrastructure code and software on isolated target platforms. Used alongside ServerSpec, we can write RSpec tests for checking if servers will be configured properly. For more information, see: https://github.com/test-kitchen/test-kitchen and http://serverspec.org/.
```
> cd cookbook
> bundle exec kitchen verify
```

