namespace Mercury.Core

import System
import System.Web
import Microsoft.Practices.ServiceLocation

public class MercuryHttpHandler(IHttpHandler):
  _container as IServiceLocator
  _routeActionType as Type
  
  public def constructor(container as IServiceLocator, routeActionType as Type):
    _container = container
    _routeActionType = routeActionType
    
  public IsReusable as bool:
    get:
      return false

  public def ProcessRequest(httpContext as HttpContext) as void:
    raise "holy shit!"