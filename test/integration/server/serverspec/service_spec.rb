# Encoding: utf-8

require_relative './spec_helper'

describe 'syslog-ng server' do

  it "is running" do
    expect(service("syslog-ng")).to be_running
    expect(service("syslog-ng")).to be_enabled
  end

  it "is listening on port 1028" do
    expect(port(1028)).to be_listening
  end

  it "is listening on port 1029" do
    expect(port(1029)).to be_listening
  end

  it "has a valid conf file" do
    conf_file = "/etc/syslog-ng/syslog-ng.conf"
    expect(file(conf_file)).to be_file
    expect(file(conf_file)).to be_mode(640)
    expect(file(conf_file)).to be_owned_by('root')
    expect(file(conf_file).content).to match(/port\(1028\)/)
    expect(file(conf_file).content).to match(/port\(1029\)/)
  end

  it "has log storage directory" do
    expect(file("/log_data")).to be_directory
  end
end
