namespace Mercury.Core

import System
import System.Web

public class RedirectBuilder:
  public def constructor():
    pass
  
  public def GetRedirect(response as HttpResponseBase, url as string):
    return RedirectResult(response, url)

