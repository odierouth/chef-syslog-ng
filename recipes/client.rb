unless Chef::Config[:solo]
  syslog_server = Discovery.search("logging_server", :node => node)

  ip_address = Discovery.ipaddress(:remote_node => syslog_server, :node => node)

  node.set[:syslog_ng][:log_host] = ip_address
end

include_recipe "syslog-ng::default"

if node[:syslog_ng][:use_tls] == true
  include_recipe "x509"

  x509_ca_certificate node[:syslog_ng][:ca_name] do
    cacertificate "#{node[:syslog_ng][:config_dir]}/cert.d/cacert.pem"
  end

  ruby_block "establish_cacert_hash" do
    block do
      sslhash = Mixlib::ShellOut.new("/usr/bin/openssl x509 -noout -hash -in #{node[:syslog_ng][:config_dir]}/cert.d/cacert.pem")
      sslhash.run_command
      cacert_hash = sslhash.stdout
      if cacert_hash.chomp != node[:syslog_ng][:cacert_hash]
        node.set[:syslog_ng][:cacert_hash] = cacert_hash.chomp
        lnhash = MixLib::ShellOut.new("ln -s #{node[:syslog_ng][:config_dir]}/cert.d/cacert.pem #{node[:syslog_ng][:config_dir]}/cert.d/#{node[:syslog_ng][:cacert_hash]}.0")
        lnhash.run_command
        Chef::Log.info("cacert link created to filename: #{node[:syslog_ng][:cacert_hash]}.0")
      end
    end
  end

end
