# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hoccer-api}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["hoccer GmbH"]
  s.date = %q{2010-10-27}
  s.description = %q{ Simple hoccer api clients }
  s.email = %q{info@hoccer.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.textile"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.textile",
     "Rakefile",
     "VERSION",
     "lib/geo_store_client.rb",
     "lib/linccer_client.rb",
     "test/helper.rb",
     "test/test_geo_store_client.rb",
     "test/test_linccer_client.rb"
  ]
  s.homepage = %q{http://github.com/hoccer/ruby-api}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{ Simple hoccer api clients }
  s.test_files = [
    "test/helper.rb",
    "test/test_geo_store_client.rb",
    "test/test_linccer_client.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

