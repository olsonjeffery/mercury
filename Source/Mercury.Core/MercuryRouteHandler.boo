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
  _viewEngines as ViewEngineCollection
  
  def constructor(container as IServiceLocator, routeType as Type, viewEngines as ViewEngineCollection):
    _container = container
    _factory = RouteActionFactory(_container)
    _routeType = routeType    
    _viewEngines = viewEngines
  
  public def GetHttpHandler(requestContext as RequestContext) as IHttpHandler:
    routeAction = _factory.CreateInstanceOf(_routeType)
    routeAction.ViewEngines = _viewEngines
    handler = MercuryHttpHandler(routeAction)
    handler.RequestContext = requestContext
    return handler