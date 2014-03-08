#
# Recipe to install eventlog and syslog-ng from source on clients
#

if platform?("redhat", "centos")
  package "gcc"
  package "make"
  package "openssl-devel"
  package "glib2-devel"
end

remote_file "#{Chef::Config[:file_cache_path]}/eventlog_#{node[:eventlog][:version]}.tar.gz" do
  source "#{node[:eventlog][:url]}/eventlog_#{node[:eventlog][:version]}.tar.gz"
  checksum node[:eventlog][:checksum]
  notifies :run, "bash[install_eventlog]", :immediately
end

bash "install_eventlog" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -xzpf eventlog_#{node[:eventlog][:version]}.tar.gz
    (cd eventlog-#{node[:eventlog][:version]} && ./configure && make && make install)
  EOH
  action :nothing
end

remote_file "#{Chef::Config[:file_cache_path]}/syslog-ng_#{node[:syslog_ng][:version]}.tar.gz" do
  source "#{node[:syslog_ng][:url]}/#{node[:syslog_ng][:version]}/source/syslog-ng_#{node[:syslog_ng][:version]}.tar.gz"
  checksum node[:syslog_ng][:checksum]
  notifies :run, "bash[install_syslog-ng]", :immediately
end

bash "install_syslog-ng" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -xzpf syslog-ng_#{node[:syslog_ng][:version]}.tar.gz
    (cd syslog-ng-#{node[:syslog_ng][:version]} && PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/ ./configure && make && make install && ldconfig)
  EOH
  action :nothing
end

cookbook_file "/etc/init.d/syslog-ng" do
  source "syslog-ng"
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
  mode 00755
end

cookbook_file "/etc/sysconfig/syslog-ng" do
  source "syslog-ng_sysconfig"
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
  mode 00644
end

directory node[:syslog_ng][:config_dir] do
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
  mode 00755
end

directory "#{node[:syslog_ng][:config_dir]}/cert.d" do
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
  mode 00755
end
