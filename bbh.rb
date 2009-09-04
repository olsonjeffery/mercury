require 'find'
require 'rexml/document'

# BooBuildHelper (Bbh)
class Bbh
  def initialize()
  end
  
  # public stuff
  def self.findBooFilesIn(baseDir)
    findFilesWithExtensionInBaseDir(baseDir, '.boo').join(' ')
  end
  
  def self.referenceAssemblies(assemblies)
    cleanAsms = []
    assemblies.each do |path|
      temp = convertToPlatformSeparator(path)
      cleanAsms.push(temp)
    end
    "-r:"+cleanAsms.join(',') + ' '
  end
  
  def self.dllTarget
    '-target:library '
  end

  def self.exeTarget
    '-target:exe '
  end

  def self.referenceDependenciesInMSBuild(path, isRelativePath)
    path = convertToPlatformSeparator(path)
    projFile = REXML::Document.new File.read(path)
    dirName = File.dirname(path)
    
    asmNames = []
    hintPaths = []
    projFile.elements.each('Project/ItemGroup/Reference') do |reference|
      asmNames.push reference.attributes['Include']
      if reference.elements['HintPath'] != nil
        reference.elements.each('HintPath') do |path|
          if isRelativePath
            hintPaths.push convertToPlatformSeparator(dirName + "/" + path.text)
          else
            hintPaths.push convertToPlatformSeparator(path.text)
          end
        end
      else
        hintPaths.push '' 
      end
    end
    refs = []
    asmNames.each_with_index do |asmName, i|
      if hintPaths[i] == '' 
        refs.push asmName
      else
        refs.push hintPaths[i]
      end
    end
    referenceAssemblies(refs)
  end
  
  def self.convertToPlatformSeparator(path)
    separator = File::SEPARATOR
    if isWindowsPlatform
      puts 'feg'
      separator = File::ALT_SEPARATOR
    end
    path.gsub(/(\\|\/)/, separator)
  end
  
  def self.isWindowsPlatform
    proc, platform, *rest = RUBY_PLATFORM.split('-')
    if platform == 'mswin32'
      return true
    else
      return false
    end
  end


  # internal stuff
  def self.findFilesWithExtensionInBaseDir(baseDir, extension)
    arr = []
    baseDir = convertToPlatformSeparator(baseDir)
    exploreDirSearchForFilesAndStoreInList(baseDir, extension, arr)
    arr.uniq
  end

  def self.exploreDirSearchForFilesAndStoreInList(dir, extension, arr)
    Find.find(dir) do |path|
      if path == dir
        next
      end
      if FileTest.directory?(path)
        exploreDirSearchForFilesAndStoreInList(path, extension, arr)
      else
        if File.extname(path).downcase == extension
          arr.push(convertToPlatformSeparator(path))
        end
      end
    end
  end

end
