# -*- encoding: utf-8 -*-
require File.expand_path("../lib/archive_2s/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "archive_2s"
  s.version     = Archive2s::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['SmashTank Apps, LLC','Eric Harrison']
  s.email       = ['dev@smashtankapps.com']
  s.homepage    = "http://rubygems.org/gems/archive_2s"
  s.summary     = "A little gem that will archive the to_s of ActiveRecord Models"
  s.description = "Sometimes you just need a descriptive value of an item you are archiving.  This is what archive_2s was made for."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "archive_2s"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'

  s.add_development_dependency "rspec"
  s.add_development_dependency "rails"
  s.add_development_dependency "sqlite3"
end
