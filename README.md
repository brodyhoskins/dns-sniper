# dns-sniper

dns-sniper is a command line utility that combines online DNS blacklists and combines them into the desired configuration format.

## Supported Formats

### Input formats

* HOSTS
* Plaintext (hostnames as newline-seperated list)

### Output formats

* dnsmasq
* Plaintext (hostnames as newline-seperated list)
* Unbound

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

# Block domain names
hostnames.add_from('https://pgl.yoyo.org/as/serverlist.php?hostformat=hosts;showintro=0;mimetype=plaintext') # From the web
hostnames.add_from('https://raw.githubusercontent.com/brodyhoskins/dns-blocklists/master/tracking.list')
hostnames.add_from('~/.config/dns-sniper/blocklists.list') # From filesystem

# Remove whitelisted domain names
hostnames.remove_from('~/.config/dns-sniper/whitelisted-hostnames.list')
hostnames.remove_from('https://example.com/whitelisted.hosts')

# Convert to configuration file
hostnames.to_text
hostnames.to_unbound
```

### From CLI

See `dns-sniper --help`

Using the CLI version makes it easy to update the automatically. For example:

```bash
#!/usr/bin/env bash

/path/to/dns-sniper -f ~/.config/dns-sniper/blacklist.list -w ~/.config/dns-sniper/whitelist.list -o unbound > /etc/unbound/unbound.conf.t/blocklist.conf

service unbound reload
```