# Elasticsearch Profile
include ::java

class { 'elasticsearch':
  manage_repo  => true,
  repo_version => '1.4',
  version      => '1.4.2',
  require      => Class['java'],
}

elasticsearch::instance { 'aiddata':
  config => {
    'plugin.mandatory'                                => 'cloud-aws',
    'discovery'                                       => {
      'type' => 'ec2',
    },
    'discovery.ec2.tag.es-cluster'                    => 'aiddata-prod', # This should be different so this profile can be reused
    'cluster.routing.allocation.awareness.attributes' => 'aws_availability_zone',
    'cloud.node.auto_attributes'                      => true,
    'discovery.ec2.ping_timeout'                      => '10s',
  },
}

elasticsearch::plugin { 'elasticsearch/elasticsearch-cloud-aws/2.4.2':
  instances => 'aiddata',
}

elasticsearch::plugin { 'com.github.richardwilly98.elasticsearch/elasticsearch-river-mongodb/2.0.5':
  instances => 'aiddata',
}

elasticsearch::plugin { 'elasticsearch/elasticsearch-lang-javascript/2.4.1':
  instances => 'aiddata',
}

elasticsearch::plugin { 'elasticsearch/elasticsearch-mapper-attachments/2.4.3':
  instances => 'aiddata',
}

# MongoDB Profile
include ::apt
Class['Apt::Update'] -> Package['mongodb_server']

class { 'mongodb::globals':
  manage_package_repo => true,
  version             => '2.6.6',
}

class { 'mongodb::server':
  # replset         => 'rs0', # This should be more variable
  smallfiles      => true, # This is false in production, but true here so it fits in our small vagrant machine
  bind_ip         => [
    '0.0.0.0',
  ],
  # replset_members => [
  #   '127.0.0.1:27017',
  # ],
  require         => Class['::mongodb::globals'],
}

# RabbitMQ Profile
class { 'rabbitmq':
  repos_ensure => true,
}

# PostgreSQL Profile
class { 'postgresql::globals':
  manage_package_repo => true,
  version             => '9.3',
  before              => Class['postgresql::server'],
}

class { 'postgresql::server':
  ip_mask_allow_all_users => '0.0.0.0/0',
  listen_addresses        => '*',
}

postgresql::server::db { 'ad_internal':
  user     => 'ad_internal',
  password => postgresql_password('ad_internal', 'password'),
}

# Development Only Things
package { 'maven2':
  ensure => installed,
}

class {'::nodejs':
  manage_package_repo => true,
  repo_url_suffix     => '0.12',
}

package { 'mongodb-org-tools':
  ensure  => installed,
  require => Class['mongodb::server'],
}

package { 'mongodb-org-shell':
  ensure  => installed,
  require => Class['mongodb::server'],
}

Class['::nodejs'] -> Package <| provider == 'npm' |>

package { 'bower':
  ensure   => '1.3.10',
  provider => 'npm',
}

package { 'grunt-cli':
  ensure   => '0.1.13',
  provider => 'npm',
}
