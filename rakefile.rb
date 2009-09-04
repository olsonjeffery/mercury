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


task :mbuild do
  sh booc + "foo.boo"
end

namespace :projects do
  
  BooLang = "Libraries/boo/Boo.Lang.dll"
  BooLangCompiler = "Libraries/boo/Boo.Lang.Compiler.dll"
  BooLangUseful = "Libraries/boo/Boo.Lang.Useful.dll"
  MicrosoftPracticesServiceLocation = "Libraries/CommonServiceLocator/Microsoft.Practices.ServiceLocation.dll"
  SystemWeb = "System.Web"
  SystemWebAbstractions = "System.Web.Abstractions"
  SystemWebExtensions = "System.Web.Extensions"
  SystemWebMvc = "Libraries/MVC/System.Web.Mvc.dll"
  SystemWebRouting = "System.Web.Routing"
  SystemXml = "System.Xml"
  
  task :core do
    name = 'Mercury.Core'
    refs = [BooLang, BooLangCompiler, BooLangUseful, MicrosoftPracticesServiceLocation, SystemWeb, SystemWebExtensions, SystemWebRouting, SystemWebAbstractions, SystemXml, SystemWebMvc]
    sh booc + '-o:Mercury.Core.dll ' + Bbh.dllTarget + Bbh.referenceDependenciesInMSBuild('Source/Mercury.Core/Mercury.Core.booproj', true) + Bbh.findBooFilesIn('Source\Mercury.Core')
  end
end

