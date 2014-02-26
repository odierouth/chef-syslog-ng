syslog-ng Cookbook
=================
A cookbook to be used for building a centralized logging framework with syslog-ng. This cookbook can be used for both the central logging server and the distributed clients throughout your infrastructure.

SSL encryption of log transmission is provided as an attribute option and SSL implementation utilized SSL cookbook listed in Requirements.

Requirements
------------
#### OS requirements
Only tested on CentOS and RedHat Enterprise Linux. Additional platform support in progress.

#### cookbooks
- `discovery` - Cookbook to support locating logging server dynamically as clients are added
- `ssl` (optional) - SSL cookbook to provide certificate management and signing via private CA. ssl cookbook used can be found on [github](https://github.com/VendaTech/chef-cookbook-ssl/tree/7429a77c3049029ec8ced768299c429fa2b715cc) -- Note: cookbook has since changed name to `x509`. This cookbook will need some refactoring to support new version.

Attributes
----------
#### configuration options
- `node[:syslog_ng][:meta_data_context]` - This is the SDATA context used within syslog-ng messages to send meta data with an event for storage organization and indexing assistance.  Default value is 'default'
- `node[:syslog_ng][:use_tls]` - Flag to utilize TLS connections for remote logging. Setting 'true' will require ssl cookbook mentioned above.
- `node[:syslog_ng][:disable_other_syslog]` - Flag to disable other running syslog applications if needed. Default is 'false'
- `node[:syslog_ng][:port_public]` - Port to be used for connections across public networks when public IP is needed. If left blank, no port will be set for listening.
- `node[:syslog_ng][:port_private]` - Port to be used for connections on private network. If left blank, no port will be set for listening.

#### Server specific
- `node[:syslog_ng][:server_log_path]` - Desitnation path on logging server to save incoming logs.

#### Client environment specific
- `node[:env_name]` - Name of environment for this host.  e.g. 'production' or 'staging'
- `node[:app_name]` - Logical name of application this host provides to overall infrastructure

Usage
-----
#### syslog-ng::server - Central syslog-ng server setup
Add the `syslog-ng::server` recipe to the run list of the central logging host to install and configure syslog-ng to receive log messages on the ports defined in attributes. Incoming messages will be stored in a directory structure defined by the environment, logical application and then node name of the client sending the logs. See below if TLS encryption is desired.

#### syslog-ng::client - Client install
Add the `syslog-ng::client` recipe to any host's run list to install syslog-ng with centralized logging host set via descovery cookbook and ports set as defined in attributes. Set the following attributes in environment/role, or via wrapper cookbook to organize logs correctly on the loging server.
- `node[:env_name]`
- `node[:app_name]`

#### Adding log to centralized logging via `syslog_ng_app` definition
Add log files in another cookbook to the centralized logging framework
```
include_recipe'syslog-ng'

syslog_ng_app "service_name" do
  log_path "/path/to/logfile"
  index "02"
end
```
#####options available
- log_path:  path or logfile to be used for source
- name:  name of service to be used in meta data for centrally stored logs
- index:  numeric index to control order of config loading by syslog-ng client
- facility:  default syslog facility used for this logging source

#### Using TLS for logging
When setting `node[:syslog_ng][:use_tls] = true` ssl cookbook is used to create certificates for the central logging server. CA Certificate is distributed to all client hosts for trust. More specific detail can be found [here](https://github.com/VendaTech/chef-cookbook-ssl#signing-client) about workflow and signing certs.
Using TLS requires setting at least one of the following attributes:
- `node[:syslog_ng][:port_public]`
- `node[:syslog_ng][:port_private]`
