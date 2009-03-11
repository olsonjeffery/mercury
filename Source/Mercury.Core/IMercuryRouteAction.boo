namespace Mercury.Core

import System.Web

public interface IMercuryRouteAction:
  def Execute()
  RouteString as string:
    get
  HttpMethod as string:
    get
  HttpContext as HttpContext:
    get
    set
  
