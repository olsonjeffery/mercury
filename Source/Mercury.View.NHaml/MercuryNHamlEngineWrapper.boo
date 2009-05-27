namespace Mercury.Core

import System
import System.IO
import NHaml
import NHaml.Web.Mvc
import System.Web
import System.Web.Routing
import System.Web.Mvc

public class MercuryNHamlViewEngine(NHamlMvcViewEngine):
  
  public def constructor():
    pass
  
  public def CreateView(controllerContext as ControllerContext, viewPath as string, masterPath as string):
    templatePath = VirtualPathToPhysicalPath(controllerContext.RequestContext, viewPath)
    masterPath = VirtualPathToPhysicalPath(controllerContext.RequestContext, masterPath)
    return TemplateEngine.Compile(
    templatePath,
    masterPath,
    GetViewBaseType(controllerContext)).CreateInstance() as IView;
  
  public override def VirtualPathToPhysicalPath(requestContext as RequestContext, viewPath as string):
    rootPath = requestContext.HttpContext.Request.PhysicalApplicationPath
    return rootPath + "Views" + Path.DirectorySeparatorChar + (viewPath if not viewPath.Substring(0,1).Equals("/") else viewPath.Substring(1, viewPath.Length-1)).Replace("/", Path.DirectorySeparatorChar.ToString())