# -*- encoding: utf-8 -*-
# stub: hobo_rapid 2.2.6 ruby lib vendor

Gem::Specification.new do |s|
  s.name = "hobo_rapid"
  s.version = "2.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib", "vendor"]
  s.authors = ["Tom Locke, Bryan Larsen"]
  s.date = "2016-05-07"
  s.description = "The RAPID tag library for Hobo"
  s.email = "tom@tomlocke.com"
  s.homepage = "http://hobocentral.net"
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubyforge_project = "hobo"
  s.rubygems_version = "2.2.2"
  s.summary = "The RAPID tag library for Hobo"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hobo>, ["= 2.2.6"])
    else
      s.add_dependency(%q<hobo>, ["= 2.2.6"])
    end
  else
    s.add_dependency(%q<hobo>, ["= 2.2.6"])
  end
end
