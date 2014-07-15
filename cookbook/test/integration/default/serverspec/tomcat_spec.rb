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
