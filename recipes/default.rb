include_recipe "syslog-ng::source"

config_source = node[:syslog_ng][:role].eql?("server")  ? "syslog-ng.server.conf.erb" : "syslog-ng.conf.erb"

template "#{node[:syslog_ng][:config_dir]}/syslog-ng.conf" do
  source config_source
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
  mode 00640
  variables({
    :host_name => node.name,
    :env_name => node[:env_name], #NOTE need to make sure this attribute gets set in each chef environment used
    :app_name => node[:app_name], #NOTE make sure this attribute gets set in each meta defining role
    :syslog_ng => node[:syslog_ng]
  })
end

directory "#{node[:syslog_ng][:config_dir]}/conf.d" do
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
  mode 00755
end

template "#{node[:syslog_ng][:config_dir]}/scl.conf" do
  source "scl.conf.erb"
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
  mode 00640
end

if node[:syslog_ng][:disable_other_syslog] == true
  #disable default EY syslog app
  service "sysklogd" do
    action [ :disable, :stop ]
  end

  #disable default EY syslog app
  service "rsyslog" do
    action [ :disable, :stop ]
  end
end

#start syslog-ng with config
service "syslog-ng" do
  supports :restart => true, :status => true
  action [ :enable, :start ]
end
