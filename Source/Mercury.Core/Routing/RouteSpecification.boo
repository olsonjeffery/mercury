namespace Mercury.Core

import System

public class RouteSpecification:
  [Property(RouteString)]
  _routeString as string
  
  [Property(HttpMethod)]
  _method as string
  
  public def constructor(routeString as string, method as string):
    _routeString = routeString
    _method = method

