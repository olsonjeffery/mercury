namespace Mercury.Core

import System

public class AspNetMvcPathSplitKludge:
"""Description of AspNetMvcPathSplitKludge"""
  public def constructor():
    pass

  public def SplitPath(path as string, stripExtension as bool, extension as string) as List[of string]:
    noExtensionPath = (path if not stripExtension else StripFileExtensionIfPresent(path, extension))
    splitUpPath = List of string(noExtensionPath.Split(char('/')))
    controller as string = string.Empty
    controller = ("" if splitUpPath.Count == 1 else splitUpPath[0])
    foo = ""
    view = (splitUpPath[0] if splitUpPath.Count == 1 else noExtensionPath.Remove(0, controller.Length + 1))
    
    result = List of string()
    result.Add(controller)
    result.Add(view)
    
    return result
  
  public def StripFileExtensionIfPresent(path as string, extension as string) as string:
    retPath = string.Empty
    pathEndsWithExtension = path.ToLower().EndsWith(extension.ToLower())
    retPath = (path.Substring(0, path.Length - extension.Length) if pathEndsWithExtension else path)
    return retPath
    