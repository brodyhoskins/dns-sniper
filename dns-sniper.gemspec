Gem::Specification.new do |spec|
  spec.name = "dns-sniper"
  spec.license = "MIT"
  spec.version = "0.0.1pre"
  spec.date = "2020-08-13"
  spec.authors = ["Brody Hoskins"]
  spec.email = ["brody@brody.digital"]

  spec.summary = "Command line utility that combines online DNS blacklists and combines them into the desired configuration format"
  spec.description = "Command line utility that combines online DNS blacklists and combines them into the desired configuration format"
  spec.homepage = "https://github.com/brodyhoskins/dns-sniper"

  spec.files = `git ls-files`.split($/)

  spec.bindir = "bin"
  spec.executables = "sniper"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.2"

  spec.add_development_dependency "down", "~> 5.1"
  spec.add_development_dependency "hosts_file", "~> 1.0"
end
