namespace Mercury.Core

import System
import System.Web
import System.Web.Routing

public class MercuryRoute(Route):  
  [property(HttpMethod)]
  _httpMethod as string
  
  //public def constructor(url as string, routeHandler as MercuryRouteHandler)
  
  public def constructor(url as string, routeHandler as MercuryRouteHandler, method as string):
    super(url, routeHandler)
    _httpMethod = method
    
  public override def GetRouteData(httpContext as HttpContextBase) as RouteData:
    routeData = super.GetRouteData(httpContext)
    return null if httpContext.Request.HttpMethod != _httpMethod and not _httpMethod == 'ANY'
    return routeData