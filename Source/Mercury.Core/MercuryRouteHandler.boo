namespace Mercury.Core

import System
import System.Web
import System.Web.Routing
import System.Web.Mvc
import Microsoft.Practices.ServiceLocation

public class MercuryRouteHandler(IRouteHandler):
  _container as IServiceLocator
  _routeType as Type
  _factory as RouteActionFactory
  
  def constructor(container as IServiceLocator, routeType as Type, viewEngines as object):
    _container = container
    _factory = RouteActionFactory(_container)
    _routeType = routeType    
  
  public def GetHttpHandler(requestContext as RequestContext) as IHttpHandler:
    routeAction = _factory.CreateInstanceOf(_routeType)
    handler = MercuryHttpHandler(routeAction)
    handler.RequestContext = requestContext
    return handler