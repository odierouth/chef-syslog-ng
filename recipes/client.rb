syslog_server = Discovery.search("logging_server", :node => node)

ip_address = Discovery.ipaddress(:remote_node => syslog_server, :node => node)

node.set[:syslog_ng][:log_host] = ip_address

include_recipe "syslog-ng::default"

if node[:syslog_ng][:use_tls] == true
  include_recipe "ssl"

  ssl_ca_certificate "DevOps CA" do
    cacertificate "#{node[:syslog_ng][:config_dir]}/cert.d/cacert.pem"
  end

  ruby_block "establish_cacert_hash" do
    block do
      cacert_hash = `/usr/bin/openssl x509 -noout -hash -in #{node[:syslog_ng][:config_dir]}/cert.d/cacert.pem`
      if cacert_hash.chomp != node[:syslog_ng][:cacert_hash]
        node.set[:syslog_ng][:cacert_hash] = cacert_hash.chomp
        `ln -s #{node[:syslog_ng][:config_dir]}/cert.d/cacert.pem #{node[:syslog_ng][:config_dir]}/cert.d/#{node[:syslog_ng][:cacert_hash]}.0`
        Chef::Log.info("cacert link created to filename: #{node[:syslog_ng][:cacert_hash]}.0")
      end
    end
  end

end
