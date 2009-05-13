namespace Mercury.Core

import System
import System.Web.Mvc
import System.IO

public class JsonResultBuilder:
  _output as TextWriter
  
  public def constructor():
    pass
  
  public def GetJson(context as ControllerContext, json as object) as JsonResult:
    return JsonResult(context, json)
    