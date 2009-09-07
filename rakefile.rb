#
# $Id$
#

require 'rake'
require 'rake/testtask'
require 'pathname'
require 'fileutils'
require 'bbh.rb'
include FileUtils

task :default => :mbuild do
end

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

mspec = 'Libraries\Machine\Specifications\Machine.Specifications.ConsoleRunner.exe'
if !Bbh.isWindowsPlatform
  mspec = Bbh.convertToPlatformSeparator('mono ' + mspec)
end


task :mbuild => ['projects:examplesite', 'projects:specs']do
end


task :mclean => ['projects:remove_build_dir', 'projects:remove_examplesite_bindir'] do
end

namespace :projects do
  buildDir = 'Build'
  
  desc 'create the build directory, if needed'
  task :create_build_dir do
    Bbh.createFolderIfNeeded('Build')
  end

  desc 'remove the build directory, if it exists'
  task :remove_build_dir do
    Bbh.removeFolderIfNeeded('Build')
  end

  desc '/bin dir for Mercury.ExampleSite'
  task :create_examplesite_bindir do
    Bbh.createFolderIfNeeded('Source/Mercury.ExampleSite/bin')
  end

  desc 'remove the ExampleSite bin directory, if it exists'
  task :remove_examplesite_bindir do
    Bbh.removeFolderIfNeeded('Source/Mercury.ExampleSite/bin')
  end

  desc 'build Mercury.Core'
  task :core => :create_build_dir do
    name = 'Mercury.Core'
    projFile = 'Source/'+name+'/'+name+'.booproj'
    projDir = 'Source/'+name
    sh booc + Bbh.outputTo(buildDir, name+'.dll') + Bbh.dllTarget + Bbh.referenceDependenciesInMSBuild(projFile, buildDir, true) + Bbh.findBooFilesIn(projDir)

    Bbh.copyNonGacDependenciesTo(buildDir, projFile, true)
  end

  desc 'build Mercury.View.NHaml'
  task :viewnhaml => :core do
    name = 'Mercury.View.NHaml'
    projFile = 'Source/'+name+'/'+name+'.booproj'
    projDir = 'Source/'+name
    sh booc + Bbh.outputTo(buildDir, name+'.dll') + Bbh.dllTarget + Bbh.referenceDependenciesInMSBuild(projFile, buildDir, true) + Bbh.findBooFilesIn(projDir)

    Bbh.copyNonGacDependenciesTo(buildDir, projFile, true)
  end
  
  desc 'build Mercury.View.Spark'
  task :viewspark => :core do
    name = 'Mercury.View.Spark'
    projFile = 'Source/'+name+'/'+name+'.booproj'
    projDir = 'Source/'+name
    sh booc + Bbh.outputTo(buildDir, name+'.dll') + Bbh.dllTarget + Bbh.referenceDependenciesInMSBuild(projFile, buildDir, true) + Bbh.findBooFilesIn(projDir)

    Bbh.copyNonGacDependenciesTo(buildDir, projFile, true)
  end
  
  desc 'build Mercury.Routing'
  task :routing => :core do
    name = 'Mercury.Routing'
    projFile = 'Source/'+name+'/'+name+'.booproj'
    projDir = 'Source/'+name
    sh booc + Bbh.outputTo(buildDir, name+'.dll') + Bbh.dllTarget + Bbh.referenceDependenciesInMSBuild(projFile, buildDir, true) + Bbh.findBooFilesIn(projDir)

    Bbh.copyNonGacDependenciesTo(buildDir, projFile, true)
  end

  desc 'build Mercury.Specs'
  task :specs => [:core, :viewspark, :viewnhaml, :routing] do
    name = 'Mercury.Specs'
    projFile = 'Source/'+name+'/'+name+'.booproj'
    projDir = 'Source/'+name
    sh booc + Bbh.outputTo(buildDir, name+'.dll') + Bbh.dllTarget + Bbh.referenceDependenciesInMSBuild(projFile, buildDir, true) + Bbh.findBooFilesIn(projDir)

    Bbh.copyNonGacDependenciesTo(buildDir, projFile, true)
  end

  desc 'build Mercury.ExampleSite'
  task :examplesite => [:create_examplesite_bindir, :core, :viewspark, :viewnhaml, :routing] do
    name = 'Mercury.ExampleSite'
    projFile = 'Source/'+name+'/'+name+'.booproj'
    projDir = 'Source/'+name
    binDir = 'Source/'+name+'/bin'
    sh booc + Bbh.outputTo(binDir, name+'.dll') + Bbh.dllTarget + Bbh.referenceDependenciesInMSBuild(projFile, buildDir, true) + Bbh.findBooFilesIn(projDir)

    Bbh.copyNonGacDependenciesTo(binDir, projFile, true)
    Bbh.copyAllFilesFromTo(buildDir, binDir)
  end
end
