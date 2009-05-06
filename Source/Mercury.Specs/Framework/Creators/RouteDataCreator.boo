namespace Mercury.Specs

import System
import System.Web.Routing

public class RouteDataCreator(FixtureService[of RouteData]):
"""Description of RouteDataCreator"""
  public def constructor():
    Creation = TestRouteData()
  
  public def WithRoute(route as string):
    handler as IRouteHandler = (Creation.RouteHandler if not Creation.RouteHandler is null else null)
    Creation.Route = Route(route, handler)
  
  public def WithRouteHandler(handler as IRouteHandler):
    Creation .RouteHandler = handler