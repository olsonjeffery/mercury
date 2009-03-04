namespace Mercury.Core

import System
import System.Web.Routing

public interface IMercuryRouteAction:
  def Execute()
  RouteString as string:
    get
  HttpMethod as string:
    get
  
