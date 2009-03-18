namespace Mercury.Core

import System
import System.Web
import System.Web.Mvc
import System.Web.Routing
import Microsoft.Practices.ServiceLocation

public class MercuryHttpHandler(IHttpHandler):
  _routeAction as IMercuryRouteAction
  
  [property(RequestContext)]
  _requestContext as RequestContext
  
  public def constructor(routeAction as IMercuryRouteAction):
    _routeAction = routeAction
    
  public IsReusable as bool:
    get:
      return false
  
  public def ProcessRequest(httpContext as HttpContext) as void:
    (_routeAction as MercuryControllerBase).Execute(_requestContext)
 
 public class MercuryHttpContext(HttpContextBase):
    _httpContext as HttpContext
    
    public def constructor(httpContext as HttpContext):
      _httpContext = httpContext