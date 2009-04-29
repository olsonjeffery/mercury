namespace Mercury.Core

import System.Web
import System.Web.Mvc

public interface IMercuryRouteAction:
  def RouteBody() as object
  RouteString as string:
    get
  HttpMethod as string:
    get  
  ViewEngines as ViewEngineCollection:
    get
    set