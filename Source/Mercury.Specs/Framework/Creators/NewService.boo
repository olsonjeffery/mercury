namespace Mercury.Specs

import System
import System.Web
import System.Web.Routing
import Mercury.Core

public class NewService:
  
  public def constructor():
    pass
  
  public def RequestContext():
    return RequestContextCreator()
  
  public def RequestContext(httpContext as HttpContextBase, routeData as RouteData) as RequestContextCreator:
    return RequestContextCreator(httpContext, routeData)
  
  public def HttpContext() as HttpContextCreator:
    return HttpContextCreator()
  
  public def RouteAction() as RouteActionCreator:
    return RouteActionCreator()
  
  public def RouteAction(resultProcessor as RouteResultProcessor):
    return RouteActionCreator(resultProcessor)
  
  public static New:
    get:
      return NewService()