namespace Mercury.Core

import System
import System.Collections.Generic
import System.Web
import System.Web.Mvc
import System.Web.Routing
import Microsoft.Practices.ServiceLocation

public class MercuryHttpHandler(IHttpHandler):
  _routeAction as IMercuryRouteAction
  _behaviors as IBehavior*
  
  [property(RequestContext)]
  _requestContext as RequestContext
  
  public def constructor(routeAction as IMercuryRouteAction, behaviors as IBehavior*):
    _routeAction = routeAction
    _behaviors = behaviors
    
  public IsReusable as bool:
    get:
      return false
  
  public def ProcessRequest(httpContext as HttpContext) as void:
    controllerBase = _routeAction as MercuryControllerBase
    controllerBase.Behaviors = _behaviors
    controllerBase.ExecuteRouteAndBehaviors(_requestContext)
  
 public class MercuryHttpContext(HttpContextBase):
    _httpContext as HttpContext
    
    public def constructor(httpContext as HttpContext):
      _httpContext = httpContext