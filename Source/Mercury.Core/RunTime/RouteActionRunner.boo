namespace Mercury.Core

import System

public callable RouteActionMethod() as object

public class RouteActionRunner:
  public def constructor():
    pass
  
  public virtual def RunRouteAction(routeAction as RouteActionMethod):
    return routeAction()

