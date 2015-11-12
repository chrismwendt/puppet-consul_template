require 'spec_helper'

describe 'consul_template::config' do

  it { should compile }

  it { should contain_user('consul-template').with(:ensure => :present) }
  it { should contain_group('consul-template').with(:ensure => :present) }

  let(:defaults_file) { '/etc/default/consul-template' }

  it do
    should contain_file('/etc/consul-template/config.d').with({
      :mode => '0755',
      :owner => 'root',
      :group => 'consul-template',
      :ensure => 'directory'
    })
  end

  it do
    should contain_file('/etc/consul-template/template.d').with({
      :mode => '0755',
      :owner => 'root',
      :group => 'consul-template',
      :ensure => 'directory'
    })
  end

  it do
    should contain_file("/usr/bin/consul-template").with({
      :mode => '0750',
      :owner => 'root',
      :group => 'consul-template'
    })
  end

  it do
    should contain_file(defaults_file).with({
      :mode => '0644',
      :owner => 'root',
      :group => 'consul-template',
      :ensure => 'present'
    })
  end

  it { should contain_file(defaults_file).with_content(/CONSUL="127.0.0.1:8500"/) }
  it { should contain_file(defaults_file).with_content(/CONSUL_TOKEN=""/) }
  it { should contain_file(defaults_file).with_content(/RETRY="5s"/) }
  it { should contain_file(defaults_file).with_content(/WAIT=""/) }
  it { should contain_file(defaults_file).with_content(/MAX_STALE="1s"/) }
  it { should contain_file(defaults_file).with_content(/LOG_LEVEL="warn"/) }

  context "non-default user" do
    let(:params) {{
      :ensure => 'present',
      :user   => 'deploy'
    }}

    it { should contain_user('deploy').with(:ensure => :present) }
    it { should contain_group('deploy').with(:ensure => :present) }
    it { should contain_file('/etc/consul-template/config.d').with(:group => 'deploy') }
  end

  context "non-default params" do
    let(:params) {
      {
        :consul_host => '127.0.0.2',
        :consul_port => '8501',
        :token       => '123456',
        :retry       => '1s',
        :wait        => '5s',
        :max_stale   => '30s',
        :log_level   => 'info',
      }
    }

    it { should contain_file(defaults_file).with_content(/CONSUL="127.0.0.2:8501"/) }
    it { should contain_file(defaults_file).with_content(/CONSUL_TOKEN="123456"/) }
    it { should contain_file(defaults_file).with_content(/RETRY="1s"/) }
    it { should contain_file(defaults_file).with_content(/WAIT="5s"/) }
    it { should contain_file(defaults_file).with_content(/MAX_STALE="30s"/) }
    it { should contain_file(defaults_file).with_content(/LOG_LEVEL="info"/) }
  end
end