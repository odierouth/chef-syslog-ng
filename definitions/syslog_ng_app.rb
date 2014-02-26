#
# Cookbook Name:: syslog-ng
# Definition:: syslog_ng_app.rb
#
#

define :syslog_ng_app, :template => "syslog_ng_app.erb" do
  include_recipe "syslog-ng"

  application = {
    :name => params[:name],
    :index => params[:index] || "03",
    :cookbook => params[:cookbook] || "syslog-ng",
    :log_path => params[:log_path],
    :facility => params[:facility] || "local0"
  }

  template "#{node[:syslog_ng][:config_dir]}/conf.d/#{application[:index]}#{application[:name]}" do
    source params[:template]
    owner node[:syslog_ng][:user]
    group node[:syslog_ng][:group]
    mode 00640
    cookbook application[:cookbook]

    variables(
      :application => application,
      :params => params
    )

    notifies :restart, resources(:service => "syslog-ng")
  end
end
