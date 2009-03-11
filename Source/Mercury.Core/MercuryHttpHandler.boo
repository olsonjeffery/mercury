namespace Mercury.Core

import System
import System.Web
import Microsoft.Practices.ServiceLocation

public class MercuryHttpHandler(IHttpHandler):
  _container as IServiceLocator
  _routeActionType as IMercuryRouteAction
  
  public def constructor(routeAction as IMercuryRouteAction):
    _routeAction = routeAction
    
  public IsReusable as bool:
    get:
      return false

  public def ProcessRequest(httpContext as HttpContext) as void:
    raise "holy shit!"