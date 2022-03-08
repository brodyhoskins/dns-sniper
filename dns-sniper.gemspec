# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'dns-sniper'
  spec.license = 'MIT'
  spec.version = '0.0.1.pre10'
  spec.date = '2022-03-07'

  spec.authors = ['Brody Hoskins']
  spec.email = ['brody@brody.digital']

  spec.summary = 'Combine DNS blacklists into desired configuration format'
  spec.description = <<~DESC.gsub(/\n/, ' ').strip
    dns-sniper generates DNS configuration files based on various user-defined
    blacklists online. Configuration files can be generated for use in Ruby
    applications or from the command line.
  DESC
  spec.homepage = 'https://github.com/brodyhoskins/dns-sniper'

  spec.metadata = {
    'homepage_uri' => 'https://github.com/brodyhoskins/dns-sniper',
    'source_code_uri' => 'https://github.com/brodyhoskins/dns-sniper'
  }

  spec.files = Dir['lib/**/*']
  spec.files += Dir['[A-Z]*'] + Dir['test/**/*']
  spec.files.reject! { |fn| fn.include? 'CVS' }
  spec.require_paths = ['lib']

  spec.bindir = 'bin'
  spec.executables = 'dns-sniper'

  spec.add_dependency 'activesupport', '>= 4.2', '< 7.0.3'
  spec.add_dependency 'down', '~> 5.1'
  spec.add_dependency 'hosts_file', '~> 1.0'
end
