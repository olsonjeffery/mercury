#
# $Id$
#

require 'rake'
require 'rake/testtask'
require 'pathname'
require 'fileutils'
require 'bbh.rb'
include FileUtils

task :vssln do
  Thread.new do
    system "devenv Source/Mercury.sln"
  end
end

# This requires SharpDevelop.exe's location to be in your PATH..
# usually something like {ProgramFiles}\SharpDevelop\3.0\bin
task :sln do
  Thread.new do
    system "SharpDevelop Source/Mercury.sln"
  end
end
task :specs => "specs:view"

task :build do
  system "nant default.build build"
end

task :rebuild do
  system "nant default.build rebuild"
end

task :clean do
  system "nant default.build clean"
end

namespace :specs do
  desc "Run Server Specs"
  task :run do
    system "nant default.build runSpecs"
  end

  desc "Run and View Server Specs"
  task :view => :run do
    system "start Specs.html"
  end
end

# mono build stuff
booc = "mono Libraries/boo/booc.exe "
if Bbh.isWindowsPlatform
  booc = 'Libraries\boo\booc.exe '
end


task :mbuild => ['projects:examplesite', 'project:specs']do
end


task :mclean => 'projects:remove_build_dir' do
end

namespace :projects do
  buildDir = 'Build'

  task :create_build_dir do
    Bbh.createFolderIfNeeded('Build')
  end

  task :remove_build_dir do
    Bbh.removeFolderIfNeeded('Build')
  end

  task :core => :create_build_dir do
    name = 'Mercury.Core'
    projFile = 'Source/Mercury.Core/Mercury.Core.booproj'
    projDir = 'Source/Mercury.Core'
    sh booc + Bbh.outputTo(buildDir, name+'.dll') + Bbh.dllTarget + Bbh.referenceDependenciesInMSBuild(projFile, buildDir, true) + Bbh.findBooFilesIn(projDir)

    Bbh.copyNonGacDependenciesTo(buildDir, projFile, true)
  end

  task :viewnhaml => :core do
    name = 'Mercury.View.NHaml'
    projFile = 'Source/Mercury.View.NHaml/Mercury.View.NHaml.booproj'
    projDir = 'Source/Mercury.View.NHaml'
    sh booc + Bbh.outputTo(buildDir, name+'.dll') + Bbh.dllTarget + Bbh.referenceDependenciesInMSBuild(projFile, buildDir, true) + Bbh.findBooFilesIn(projDir)

    Bbh.copyNonGacDependenciesTo(buildDir, projFile, true)
  end

  task :viewspark => :core do
    name = 'Mercury.View.Spark'
    projFile = 'Source/Mercury.View.Spark/Mercury.View.Spark.booproj'
    projDir = 'Source/Mercury.View.Spark'
    sh booc + Bbh.outputTo(buildDir, name+'.dll') + Bbh.dllTarget + Bbh.referenceDependenciesInMSBuild(projFile, buildDir, true) + Bbh.findBooFilesIn(projDir)

    Bbh.copyNonGacDependenciesTo(buildDir, projFile, true)
  end

end

