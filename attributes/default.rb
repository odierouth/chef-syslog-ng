
default[:syslog_ng][:user] = "syslog"
default[:syslog_ng][:group] = "syslog"
default[:syslog_ng][:config_dir] = "/etc/syslog-ng"
default[:syslog_ng][:role] = 'client'
default[:syslog_ng][:meta_data_context] = 'default'

default[:syslog_ng][:use_tls] = true
default[:syslog_ng][:ca_name] = ''
default[:syslog_ng][:cacert_hash] = ''

# connection info for log server
default[:syslog_ng][:log_host] = '127.0.0.1'
default[:syslog_ng][:port_public] = ''
default[:syslog_ng][:port_private] = ''

# for eventlog source installation
default['eventlog']['url'] = 'http://www.balabit.com/downloads/files/eventlog/0.2'
default['eventlog']['version'] = '0.2.12'
default['eventlog']['checksum'] = '494dac8e01dc5ce323df2ad554d94874938dab51aa025987677b2bc6906a9c66'

# for syslog-ng source installation
default['syslog-ng']['url'] = 'http://www.balabit.com/downloads/files/syslog-ng/open-source-edition'
default['syslog-ng']['version'] = '3.3.5'
default['syslog-ng']['checksum'] = 'dcca69869ab3cf2afda6db0dad549b6be717f6cf6aa6d7f27ca10f9c4c6aaa75'
