# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{active_record_geocodable}
  s.version = "1.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marcin Nowicki"]
  s.date = %q{2009-10-21}
  s.description = %q{Allow any active record model to be geocoded by geokit gem and contain geodata}
  s.email = %q{pr0d1r2@ragnarson.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "active_record_geocodable.gemspec",
     "lib/active_record_geocodable.rb",
     "lib/active_record_geocodable/base.rb",
     "lib/active_record_geocodable/model.rb",
     "spec/active_record_geocodable_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/Pr0d1r2/active_record_geocodable}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{ActiveRecord is_geocodable method}
  s.test_files = [
    "spec/active_record_geocodable_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
