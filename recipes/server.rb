
config_dir = node[:syslog_ng][:config_dir]
node.override[:syslog_ng][:role] = "server"

include_recipe "syslog-ng::default"

directory node[:syslog_ng][:server_log_path] do
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
end

if node[:syslog_ng][:use_tls]

  #Create directory to hold private keys for TLS certs
  directory "#{config_dir}/key.d" do
    owner node[:syslog_ng][:user]
    group node[:syslog_ng][:group]
    mode 00755
  end

  #Creating TLS connection keys and certificates for logging server
  # syslog-ng requires that CN of certificates be the fqdn or IP address of server
  # Separate certificate is needed for local IP and for public IP for each kind of
  #  connection to the logging server.
  include_recipe "ssl"

  #establish private network certificate
  ssl_certificate "#{node['cloud']['local_ipv4']}" do
    ca "DevOps CA"
    key "#{node[:syslog_ng][:config_dir]}/key.d/logserver.pem"
    certificate "#{node[:syslog_ng][:config_dir]}/cert.d/logserver_cert.pem"
    cacertificate "#{node[:syslog_ng][:config_dir]}/cert.d/cacert.pem"
  end

  #establish public network certificate
  ssl_certificate "#{node['cloud']['public_ipv4']}" do
    ca "DevOps CA"
    key "#{node[:syslog_ng][:config_dir]}/key.d/logserver_inet.pem"
    certificate "#{node[:syslog_ng][:config_dir]}/cert.d/logserver_inet_cert.pem"
    cacertificate "#{node[:syslog_ng][:config_dir]}/cert.d/cacert.pem"
  end

#NOTE: remember to run chef-ssl on CA to get these certs signed and verified
end
