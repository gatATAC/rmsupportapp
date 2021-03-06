# -*- encoding: utf-8 -*-
# stub: hobo_jquery 2.2.6 ruby lib vendor taglibs

Gem::Specification.new do |s|
  s.name = "hobo_jquery"
  s.version = "2.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib", "vendor", "taglibs"]
  s.authors = ["Bryan Larsen"]
  s.date = "2016-05-07"
  s.description = "JQuery support for Hobo"
  s.email = "bryan@larsen.st"
  s.homepage = "http://hobocentral.net"
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubygems_version = "2.2.2"
  s.summary = "JQuery support for Hobo"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jquery-rails>, ["~> 2.0"])
      s.add_runtime_dependency(%q<hobo_rapid>, ["= 2.2.6"])
    else
      s.add_dependency(%q<jquery-rails>, ["~> 2.0"])
      s.add_dependency(%q<hobo_rapid>, ["= 2.2.6"])
    end
  else
    s.add_dependency(%q<jquery-rails>, ["~> 2.0"])
    s.add_dependency(%q<hobo_rapid>, ["= 2.2.6"])
  end
end
