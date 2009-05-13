namespace Mercury.Core

import System
import System.Web.Mvc

public class JsonResult(IRouteResult):
  _json as object
  _context as ControllerContext
  
  public def constructor(context as ControllerContext, json as object):
    _context = context
    _json = json
  
  public def ProcessResult():
    jsonResult = System.Web.Mvc.JsonResult()
    jsonResult.Data = _json
    jsonResult.ExecuteResult(_context)

