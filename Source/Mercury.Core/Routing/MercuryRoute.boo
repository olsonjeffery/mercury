namespace Mercury.Core.Routing

import System
import System.Reflection
import System.Web
import System.Web.Routing

public class MercuryRoute(RouteBase):
  
  private _routes as List of Route;
  
  def constructor():
    ParseReferencedAssembliesForRoutes()
  
  public def GetRouteData(httpContext as HttpContextBase) as RouteData:
    routeData = RouteData();
    routeData.RouteHandler = MercuryRouteHandler()
  
  public def GetVirtualPath(requestContext as RequestContext, routeValueDictionary as RouteValueDictionary) as VirtualPathData:
    raise "fuck!"
  
  public def ParseReferencedAssembliesForRoutes() as void:
    assemblies = System.AppDomain.CurrentDomain.GetAssemblies()
    for assembly in assemblies:
      for type in assembly.GetTypes():
        pass