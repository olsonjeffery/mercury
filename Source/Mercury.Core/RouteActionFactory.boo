namespace Mercury.Core

import System
import System.Reflection
import System.Web
import Microsoft.Practices.ServiceLocation

public class RouteActionFactory:
  
  _container as IServiceLocator
  
  public def constructor(container as IServiceLocator):
    _container = container
  
  public def CreateMercuryRouteActionFromType(type as Type) as IMercuryRouteAction:
    raise "not impl"

