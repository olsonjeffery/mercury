namespace Mercury.Specs

import System
import System.Web
import System.Web.Routing

public class NewService:
  
  public def constructor():
    pass
  
  public def RequestContext(httpContext as HttpContextBase, routeData as RouteData) as RequestContextCreator:
    return RequestContextCreator(httpContext, routeData)
  
  public def HttpContext() as HttpContextCreator:
    return HttpContextCreator()