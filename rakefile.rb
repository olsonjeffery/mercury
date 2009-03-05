#
# $Id$
#

require 'rake'
require 'rake/testtask'
require 'pathname'
require 'rubygems'
gem 'activerecord', '>=1.15.3'
require 'active_record'
require 'fileutils'
include FileUtils

task :sln do
  Thread.new do
    system "devenv Source/Mercury.sln"
  end
end

task :specs => "specs:view"

task :build do
  system "msbuild default.msbuild /t:Build"
end

namespace :specs do
  desc "Run Server Specs"
  task :run do
    system "msbuild default.msbuild /t:RunSpecs"
  end

  desc "Run and View Server Specs"
  task :view => :run do
    system "start Specs.html"
  end
end