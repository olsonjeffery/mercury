namespace Mercury.Core

import System
import System.Web.Mvc

public class RouteResultProcessor:
  public def constructor():
    pass
  
  public virtual def ProcessNullResult() as void:
    pass
  
  public virtual def ProcessIRouteResult(result as IRouteResult):
    result.ProcessResult()