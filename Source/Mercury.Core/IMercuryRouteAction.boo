namespace Mercury.Core

import System.Web

public interface IMercuryRouteAction:
  def ExecuteCore()
  RouteString as string:
    get
  HttpMethod as string:
    get  
