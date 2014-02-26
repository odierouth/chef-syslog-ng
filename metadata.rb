name              "syslog-ng"
maintainer        "Odie Routh"
maintainer_email  "odierouth@gmail.com"
license           "Apache 2.0"
description       "Installs/Configures syslog-ng for centralized logging"

version           "0.1.1"

depends   "discovery"

supports  "centos"
supports  "redhat"

# If using TLS connections for log events over public networks, ssl cookbook required
recommends  "ssl"
