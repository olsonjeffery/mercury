namespace Mercury.Core

import System
import System.Collections.Generic
import System.IO
import NHaml
import NHaml.Web.Mvc
import System.Web
import System.Web.Routing
import System.Web.Mvc
import System.Reflection

public class MercuryNHamlViewEngine(NHamlMvcViewEngine):
  
  _engine as TemplateEngine
  
  public def constructor():
    options = GetTemplateEngineOptions()
    options.AddUsing("System.Web")
    options.AddUsing("System.Web.Mvc")
    options.AddUsing("System.Web.Mvc.Html")
    options.AddUsing("System.Web.Routing")
    options.AddUsing("NHaml.Web.Mvc")
    
    _engine = TemplateEngine(options)
  
  public def GetTemplateEngineOptions():
    options = NHaml.TemplateOptions()
    for asmName as AssemblyName in GetType().Assembly.GetReferencedAssemblies():
      asm = Assembly.Load(asmName)
      options.AddReference(asm)
    return options
  
  public def CreateView(controllerContext as ControllerContext, viewPath as string, masterPath as string):
    templatePath = VirtualPathToPhysicalPath(controllerContext.RequestContext, viewPath)
    layoutPath = VirtualPathToPhysicalPath(controllerContext.RequestContext, masterPath)
    paths = List of string()
    
    paths.Add(layoutPath)
    paths.Add(templatePath)
    
    return _engine.Compile(
    paths,
    GetViewBaseType(controllerContext)).CreateInstance() as IView;
  
  public override def VirtualPathToPhysicalPath(requestContext as RequestContext, viewPath as string):
    rootPath = requestContext.HttpContext.Request.PhysicalApplicationPath
    return rootPath + "Views" + Path.DirectorySeparatorChar + (viewPath if not viewPath.Substring(0,1).Equals("/") else viewPath.Substring(1, viewPath.Length-1)).Replace("/", Path.DirectorySeparatorChar.ToString())