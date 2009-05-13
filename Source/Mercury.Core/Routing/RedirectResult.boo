namespace Mercury.Core

import System
import System.Web

public class RedirectResult(IRouteResult):
  _response as HttpResponseBase
  _url as string
  
  public def constructor(response as HttpResponseBase, url as string):
    _response = response
    _url = url
  
  public def ProcessResult():
    _response.Redirect(_url)