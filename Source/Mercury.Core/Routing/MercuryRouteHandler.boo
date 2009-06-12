namespace Mercury.Core

import System
import System.Collections.Generic
import System.Web
import System.Web.Routing
import System.Web.Mvc
import Microsoft.Practices.ServiceLocation

public class MercuryRouteHandler(IRouteHandler):
  _container as IServiceLocator
  _routeType as Type
  _factory as RunTimeTypeInstantiator
  _viewEngines as ViewEngineCollection
  _behaviors as Type*
  
  [property(RouteSpecification)]
  _routeSpec as RouteSpecification
  
  def constructor(container as IServiceLocator, routeType as Type, viewEngines as ViewEngineCollection, behaviors as Type*, routeSpec as RouteSpecification):
    _container = container
    _routeType = routeType    
    _viewEngines = viewEngines
    _behaviors = behaviors
    _routeSpec = routeSpec
    
    _factory = RunTimeTypeInstantiator(_container)
  
  public def GetHttpHandler(requestContext as RequestContext) as IHttpHandler:
    routeAction = _factory.CreateInstanceOf(_routeType)
    behaviors = _factory.CreateInstancesOfBehaviorsFrom(_behaviors)
    routeAction.ViewEngines = _viewEngines
    handler = MercuryHttpHandler(routeAction, behaviors)
    handler.RequestContext = requestContext
    return handler