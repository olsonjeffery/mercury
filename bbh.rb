require 'find'
require 'fileutils'
require 'rexml/document'
require 'ftools'

# BooBuildHelper (Bbh)
class Bbh
  def initialize()
  end
  
  def self.findBooFilesIn(baseDir)
    findFilesWithExtensionInBaseDir(baseDir, '.boo').join(' ')
  end
  
  def self.createFolderIfNeeded(path)
    Dir.mkdir(path) unless File.directory?(path)
  end

  def self.removeFolderIfNeeded(path)
    FileUtils.rm_rf path unless !File.directory?(path)
  end

  def self.outputTo(directory, fileName)
    '-o:' + convertToPlatformSeparator(directory + '/' + fileName) + ' '
  end
 
  def self.referenceAssemblies(assemblies)
    cleanAsms = []
    assemblies.each do |path|
      temp = convertToPlatformSeparator(path)
      cleanAsms.push(temp)
    end
    "-r:"+cleanAsms.join(',') + ' '
  end
   
  def self.copyNonGacDependenciesTo(buildDir, projFilePath, isRelativePath)
    buildDir = convertToPlatformSeparator(buildDir)
    path = convertToPlatformSeparator(projFilePath)
    projFile = REXML::Document.new File.read(path)
    dirName = File.dirname(path)
    hintPaths = []
    projFile.elements.each('Project/ItemGroup/Reference') do |reference|
      if reference.elements['HintPath'] != nil
        reference.elements.each('HintPath') do |path|
          if isRelativePath
            hintPaths.push convertToPlatformSeparator(dirName + "/" + path.text)
          else
            hintPaths.push convertToPlatformSeparator(path.text)
          end
        end
      end
    end

    hintPaths.each do |path|
      File.copy(path, buildDir)
    end
  end

  def self.copyAllFilesFromTo(fromPath, toPath)
    fromPath = convertToPlatformSeparator(fromPath)
    toPath = convertToPlatformSeparator(toPath)
    files = []
    exploreDirSearchForFilesAndStoreInList(fromPath, nil, files)
    files.each do |path|
      File.copy(path, toPath)
    end
  end
 
  def self.dllTarget
    '-target:library '
  end

  def self.exeTarget
    '-target:exe '
  end

  def self.referenceDependenciesInMSBuild(path, projectRefsBinPath, isRelativePath)
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
    projRefs = referenceProjectReferences(convertToPlatformSeparator(projectRefsBinPath), projFile)
    projRefs.each do |ref|
      refs.push ref
    end
    referenceAssemblies(refs)
  end

  def self.referenceProjectReferences(referenceBinsPath, projFile)
    refs = []
    projFile.elements.each('/Project/ItemGroup/ProjectReference/Name') do |name|
      puts name.text
      refs.push(convertToPlatformSeparator(referenceBinsPath + '/' + name.text + '.dll'))
    end
    refs
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
        if extension == nil || File.extname(path).downcase == extension
          arr.push(convertToPlatformSeparator(path))
        end
      end
    end
  end

end


