require 'chefspec'
require_relative 'spec_helper'

describe 'cb-tomcat::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'includes the java::default recipe' do
    expect(chef_run).to include_recipe('java::default')
  end

  it 'includes the cb-tomcat::tomcat recipe' do
    expect(chef_run).to include_recipe('cb-tomcat::tomcat')
  end

end
