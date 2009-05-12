namespace Mercury.Core

import System
import System.Collections.Generic
import System.Text.RegularExpressions
import System.Linq.Enumerable from System.Core

public class RouteParameterNameExtractor:
  
  public def constructor():
    pass
  
  
  _getParams as Regex = Regex("\\{\\w+\\}")
  public virtual def GetParametersFrom(route as string) as string*:
    matches = _getParams.Matches(route)
    params = (i.Value.Replace("{", string.Empty).Replace("}", string.Empty) for i as Match in matches).ToList()
    return params