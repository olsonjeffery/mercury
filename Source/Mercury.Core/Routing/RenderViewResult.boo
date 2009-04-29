namespace Mercury.Core

import System
import System.IO
import System.Web.Mvc

public class RenderViewResult(IRouteResult):
  _viewContext as ViewContext
  _viewEngineResult as ViewEngineResult
  _responseOutput as TextWriter
  
  public def constructor(viewContext as ViewContext, viewEngineResult as ViewEngineResult, responseOutput as TextWriter):
    _viewContext = viewContext
    _viewEngineResult = viewEngineResult
    _responseOutput = responseOutput
  
  public def ProcessResult():
    _viewEngineResult.View.Render(_viewContext, _responseOutput)