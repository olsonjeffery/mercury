namespace Mercury.Core

import System
import System.Collections.Generic
import System.Reflection
import System.Web
import System.Web.Routing
import Microsoft.Practices.ServiceLocation

public class MercuryEngine(RouteBase):
  
  private _uninstantiatedRoutes as IEnumerable of Type;
  private _container as object
    
  def constructor(container as IServiceLocator):
    self._container = container
    _uninstantiatedRoutes = ParseReferencedAssembliesForUninstantiatedRoutes()
  
  public def GetRouteData(httpContext as HttpContextBase) as RouteData:
    url = httpContext.Request.Url;
    method = httpContext.Request.HttpMethod;
    routeData = RouteData();
    routeData.RouteHandler = MercuryRouteHandler()
    raise "url: " + url + " method: " + method + " # of routes: " + List of Type(_uninstantiatedRoutes).Count
  
  public def GetVirtualPath(requestContext as RequestContext, routeValueDictionary as RouteValueDictionary) as VirtualPathData:
    raise "fuck!"
  
  public def ParseReferencedAssembliesForUninstantiatedRoutes() as IEnumerable of Type:
    assemblies = System.AppDomain.CurrentDomain.GetAssemblies()
    routes = List of Type();
    names = ""
    for assembly in assemblies:
      names += assembly.FullName + "\n"
      for type in assembly.GetTypes():
        if typeof(IMercuryRoute) in (type.GetInterfaces()):
          routes.Add(type)
    
    return routes