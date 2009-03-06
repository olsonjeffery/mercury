namespace Mercury.Core

import System

public class MercuryRoute:
  [property(RouteHandler)]
  _routeHandler as MercuryRouteHandler
  
  [property(Url)]
  _url as string
  
  public def constructor(url as string, routeHandler as MercuryRouteHandler):
    _routeHandler = routeHandler
    _url = url