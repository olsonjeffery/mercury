namespace Mercury.Core

import System
import System.IO
import System.Web.Mvc

public class RenderViewResult(IRouteResult):
  _viewContext as ViewContext
  _view as IView
  _responseOutput as TextWriter
  
  public def constructor(viewContext as ViewContext, view as IView, responseOutput as TextWriter):
    _viewContext = viewContext
    _view = view
    _responseOutput = responseOutput
  
  public def ProcessResult():
    _view.Render(_viewContext, _responseOutput)