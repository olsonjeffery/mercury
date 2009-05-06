namespace Mercury.Specs

import System
import System.Web.Routing

public class TestRouteData(RouteData):
  public def constructor(route as RouteBase, handler as IRouteHandler):
    super(route, handler)
  
  public def constructor(route as Route):
    super(route, route.RouteHandler)
  
  public def constructor():
    super(null, null)