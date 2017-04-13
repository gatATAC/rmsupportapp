# -*- encoding: utf-8 -*-
# stub: hobo_fields 2.2.6 ruby lib

Gem::Specification.new do |s|
  s.name = "hobo_fields"
  s.version = "2.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tom Locke"]
  s.date = "2016-05-07"
  s.description = "Rich field types and migration generator for Rails"
  s.email = "tom@tomlocke.com"
  s.executables = ["hobofields"]
  s.files = ["bin/hobofields"]
  s.homepage = "http://hobocentral.net"
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubyforge_project = "hobo"
  s.rubygems_version = "2.2.2"
  s.summary = "Rich field types and migration generator for Rails"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hobo_support>, ["= 2.2.6"])
      s.add_development_dependency(%q<RedCloth>, [">= 0"])
      s.add_development_dependency(%q<kramdown>, [">= 0"])
    else
      s.add_dependency(%q<hobo_support>, ["= 2.2.6"])
      s.add_dependency(%q<RedCloth>, [">= 0"])
      s.add_dependency(%q<kramdown>, [">= 0"])
    end
  else
    s.add_dependency(%q<hobo_support>, ["= 2.2.6"])
    s.add_dependency(%q<RedCloth>, [">= 0"])
    s.add_dependency(%q<kramdown>, [">= 0"])
  end
end
