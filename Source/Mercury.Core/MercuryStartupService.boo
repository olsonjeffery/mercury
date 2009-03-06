namespace Mercury.Core

import System
import System.Collections.Generic
import System.Reflection
import System.Web
import System.Web.Routing
import Microsoft.Practices.ServiceLocation

public class MercuryStartupService(RouteBase):
  
  private _uninstantiatedRoutes as IEnumerable of Type;
  private _container as object
  
  def constructor(container as IServiceLocator):
    self._container = container
    
  public def BuildRoutes() as IEnumerable of Route:
    _uninstantiatedRoutes = ParseReferencedAssembliesForUninstantiatedRoutes()
    routes = List of Route()
    for routeType in _uninstantiatedRoutes:
      routeAction = routeType.GetConstructor(array(typeof(Type), 0)).Invoke(array(typeof(Type), 0)) as IMercuryRouteAction
      routes.Add(Route(routeAction.RouteString, MercuryRouteHandler(_container, routeType, null)))
    
    //raise "number of routes: " + routes.Count + '\n route 0 url: '+routes[0].Url+ '\n route 1 url: '+routes[1].Url+ '\n route 2 url: '+routes[2].Url
    return routes
    
  public def GetRouteData(httpContext as HttpContextBase) as RouteData:
    url = httpContext.Request.Url;
    method = httpContext.Request.HttpMethod;
    //routeData = RouteData();
    //routeData.RouteHandler = MercuryRouteHandler()
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
        if typeof(IMercuryRouteAction) in (type.GetInterfaces()):
          routes.Add(type)
    
    return routes