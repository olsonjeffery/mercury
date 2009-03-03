namespace Mercury.Core.Routing

import System
import System.Reflection
import System.Web
import System.Web.Routing
import Microsoft.Practices.ServiceLocation

public class MercuryRoutingEngine(RouteBase):
  
  private _routes as List of Route;
  private container as object
    
  def constructor(container as object):
    self.container = container
    
    ParseReferencedAssembliesForRoutes()
  
  public def GetRouteData(httpContext as HttpContextBase) as RouteData:
    url = httpContext.Request.Url;
    method = httpContext.Request.HttpMethod;
    routeData = RouteData();
    routeData.RouteHandler = MercuryRouteHandler()
    raise "url: " + url + " method: " + method
  
  public def GetVirtualPath(requestContext as RequestContext, routeValueDictionary as RouteValueDictionary) as VirtualPathData:
    raise "fuck!"
  
  public def ParseReferencedAssembliesForRoutes() as void:
    assemblies = System.AppDomain.CurrentDomain.GetAssemblies()
    for assembly in assemblies:
      for type in assembly.GetTypes():
        pass