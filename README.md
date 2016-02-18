vagrant_aiddata-internal
========================

The development environment required to work on AidData internal.

## Setup

### Pre-requisites

* [Vagrant](https://www.vagrantup.com/)
* [r10k](https://rubygems.org/gems/r10k) Ruby Gem

### Installing Puppet Modules

Puppet modules need to be installed using r10k before the machine can be provisioned.

```bash
cd puppet/
r10k puppetfile install
```

## Use
To start the vagrant machine, run `vagrant up`. Since the machine is setup the same
way that the production environment is set up, the initial startup may take a while.
In production the various services we're installing on one machine are spread across
multiple servers.

The root of the vagrant_aiddata-internal repository is mounted at /vagrant inside
the machine.

### Ports

Ports 27017 (MongoDB), 9200 (Elasticsearch), 5433 (PostgreSQL), and 8085 (Web) listen
on 127.0.0.1 on the development machine and are mapped to the vagrant box so that
services can be accessed through desktop tools.

### SSH Access

The machine can be accessed using ssh with `vagrant ssh`. The default user can
sudo to root without a password.

### Saving State

`vagrant suspend` and `vagrant resume` can be used to avoid having to rebuild the machine each time.

### Terminating the machine

`vagrant destroy` will completely remove the running machine, including data in the
various services. Data written to the shared directory will be saved.

### Re-provisioning

Puppet can repair configuration files and packages if they were originally set by puppet
using `vagrant provision`.

## Installed Services

* Java (JDK 1.7.0_ulatest)
* PostgreSQL (9.3.latest)
* MongoDB (2.6.6)
  * Server, client, and tools
* Elasticsearch (1.4.2)
  * elasticsearch/elasticsearch-cloud-aws/2.4.2 (for backups and replica discovery in AWS)
  * com.github.richardwilly98.elasticsearch/elasticsearch-river-mongodb/2.0.5
  * elasticsearch/elasticsearch-lang-javascript/2.4.1
  * elasticsearch/elasticsearch-mapper-attachments/2.4.3
* RabbitMQ
* Maven
* NodeJS (0.12)
  * bower (1.3.10)
  * grunt-cli (0.1.13)

### Passwords

The only service that uses a password is PostgreSQL:
  - Username: ad_internal
  - Password: password
  - Database: ad_internal
