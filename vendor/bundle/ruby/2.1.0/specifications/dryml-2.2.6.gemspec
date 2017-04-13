# -*- encoding: utf-8 -*-
# stub: dryml 2.2.6 ruby lib
# stub: ext/mkrf_conf.rb

Gem::Specification.new do |s|
  s.name = "dryml"
  s.version = "2.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tom Locke"]
  s.date = "2016-05-07"
  s.description = "The Don't Repeat Yourself Markup Language"
  s.email = "tom@tomlocke.com"
  s.extensions = ["ext/mkrf_conf.rb"]
  s.files = ["ext/mkrf_conf.rb"]
  s.homepage = "http://hobocentral.net"
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubyforge_project = "hobo"
  s.rubygems_version = "2.2.2"
  s.summary = "The Don't Repeat Yourself Markup Language"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpack>, [">= 0"])
      s.add_runtime_dependency(%q<hobo_support>, ["= 2.2.6"])
      s.add_development_dependency(%q<cucumber>, ["~> 1.1.0"])
      s.add_development_dependency(%q<aruba>, ["~> 0.4.6"])
    else
      s.add_dependency(%q<actionpack>, [">= 0"])
      s.add_dependency(%q<hobo_support>, ["= 2.2.6"])
      s.add_dependency(%q<cucumber>, ["~> 1.1.0"])
      s.add_dependency(%q<aruba>, ["~> 0.4.6"])
    end
  else
    s.add_dependency(%q<actionpack>, [">= 0"])
    s.add_dependency(%q<hobo_support>, ["= 2.2.6"])
    s.add_dependency(%q<cucumber>, ["~> 1.1.0"])
    s.add_dependency(%q<aruba>, ["~> 0.4.6"])
  end
end
