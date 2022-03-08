# dns-sniper

dns-sniper is a command line utility that combines online DNS blacklists and combines them into the desired configuration format.

## Supported Formats

### Input formats

* HOSTS
* plaintext (hostnames as newline-seperated list)

### Output formats

* bind 8
* dnsmasq
* HOSTS
* plaintext (hostnames as newline-seperated list)
* unbound

## Installation

Using bundler, add to the `Gemfile`:

```ruby
gem 'dns-sniper'
```

Or standalone:

```
$ gem install dns-sniper
```

## Sample Usage

### From within Ruby

```ruby
require 'dns-sniper'

hostnames = DNSSniper::Hostnames.new

# Manually add blacklisted or whitelisted domains
hostnames.blacklist += 'ads.yahoo.com'
hostnames.whitelist += 'favoritewebsite.com'

# Use an Importer to process external lists
hostnames.blacklist += DNSSniper::DomainsImporter.new('https://raw.githubusercontent.com/brodyhoskins/dns-blocklists/master/tracking.list').hostnames
hostnames.blacklist += DNSSniper::HostsImporter.new('https://pgl.yoyo.org/as/serverlist.php?hostformat=hosts;showintro=0;mimetype=plaintext').hostnames

# Blocklist is accessible as an Array
hostnames.blocklist

# List available formats
DNSSniper::Exporters.all

# Convert to desired format
hostnames.to_unbound
```

### From CLI

See `dns-sniper --help`

Using the CLI version makes it easy to update configuration formats automatically. For example:

```bash
#!/usr/bin/env bash

/path/to/dns-sniper --conf ~/.config/dns-sniper/dns-sniper.yml --output unbound > /etc/unbound/unbound.conf.d/blocklist.conf
service unbound reload
```