# -*- encoding: utf-8 -*-
# stub: hobo_clean_admin 2.2.6 ruby lib vendor taglibs

Gem::Specification.new do |s|
  s.name = "hobo_clean_admin"
  s.version = "2.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib", "vendor", "taglibs"]
  s.authors = ["Tom Locke, James Garlick"]
  s.date = "2016-05-07"
  s.description = "The clean theme for Hobo"
  s.email = "tom@tomlocke.com"
  s.homepage = "http://hobocentral.net"
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubyforge_project = "hobo"
  s.rubygems_version = "2.2.2"
  s.summary = "The clean theme for Hobo"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hobo_clean>, ["= 2.2.6"])
    else
      s.add_dependency(%q<hobo_clean>, ["= 2.2.6"])
    end
  else
    s.add_dependency(%q<hobo_clean>, ["= 2.2.6"])
  end
end
