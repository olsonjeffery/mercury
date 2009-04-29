namespace Mercury.Core

import System
import System.Web.Mvc

public class RouteResultProcessor:
  public def constructor():
    pass

  public def Process(result as object, controllerContext as ControllerContext):
    if result is null:
      pass
    elif result isa IRouteResult:
      (result as IRouteResult).ProcessResult()
    elif result isa string:
      controllerContext.HttpContext.Response.Output.Write(result as string)
    else: // is JSON
      pass  // do implicit json conversion here