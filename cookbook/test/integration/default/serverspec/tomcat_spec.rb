require 'spec_helper'

# Java
describe command('java -version') do
  its(:stdout) do
    should match(/#{Regexp.escape("java version \"1.8.0")}/)
  end
  its(:stdout) do
    should match(/#{Regexp.escape('(TM) SE Runtime Environment (build 1.8.0')}/)
  end
  its(:stdout) do
    should match(/#{Regexp.escape('Java HotSpot(TM) 64-Bit Server VM')}/)
  end
end

# Tomcat
describe service('tomcat') do
  it { should be_enabled   }
  it { should be_running   }
end
describe port(8080) do
  it { should be_listening }
end
describe port(8005) do
  it { should be_listening }
end
