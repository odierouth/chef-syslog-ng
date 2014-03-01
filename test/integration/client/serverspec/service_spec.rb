# Encoding: utf-8

require_relative './spec_helper'

describe 'syslog-ng client' do

  it "is running" do
    expect(service("syslog-ng")).to be_running
    expect(service("syslog-ng")).to be_enabled
  end

  it "has a valid conf file" do
    conf_file = "/etc/syslog-ng/syslog-ng.conf"
    expect(file(conf_file)).to be_file
    expect(file(conf_file)).to be_mode(640)
    expect(file(conf_file)).to be_owned_by('root')
    expect(file(conf_file).content).to match(/set\(\"integration\", value\(\"\.SDATA\.default\.env\"/)
    expect(file(conf_file).content).to match(/syslog\(\"127\.0\.0\.1\" port\(1028\)/)
  end

end

