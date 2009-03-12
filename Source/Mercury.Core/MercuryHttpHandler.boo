namespace Mercury.Core

import System
import System.Web
import Microsoft.Practices.ServiceLocation

public class MercuryHttpHandler(IHttpHandler):
  _routeAction as IMercuryRouteAction
  
  public def constructor(routeAction as IMercuryRouteAction):
    _routeAction = routeAction
    
  public IsReusable as bool:
    get:
      return false

  public def ProcessRequest(httpContext as HttpContext) as void:
    _routeAction.HttpContext = httpContext
    _routeAction.Execute()