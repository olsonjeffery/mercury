namespace Mercury.Core

import System
import System.Web
import System.Web.Routing
import System.Web.Mvc
import Microsoft.Practices.ServiceLocation

public class MercuryRouteHandler(IRouteHandler):
  _container as IServiceLocator
  _routeType as Type
  
  def constructor(container as IServiceLocator, routeType as Type, viewEngines as object):
    _container = container
    _routeType = routeType
  
  public def GetHttpHandler(requestContext as RequestContext) as IHttpHandler:
    raise "method: '"+requestContext.HttpContext.Request.HttpMethod+"' url: "+requestContext.HttpContext.Request.Url + " type of action: "+_routeType.GetType().ToString()