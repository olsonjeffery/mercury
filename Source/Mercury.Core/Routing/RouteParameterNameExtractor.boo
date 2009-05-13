namespace Mercury.Core

import System
import System.Collections.Generic
import System.Text.RegularExpressions
import System.Linq.Enumerable from System.Core

public class RouteParameterNameExtractor:
  
  public def constructor():
    pass
  
  
  _getParams as Regex = Regex("\\{[^\\}]+\\}")
  public virtual def GetParametersFrom(route as string) as string*:
    matches = _getParams.Matches(route)
    params = (i.Value.Replace("{", string.Empty).Replace("}", string.Empty) for i as Match in matches).ToList()
    pattern = @/[^_a-zA-Z0-9]/
    params = (pattern.Replace(i, string.Empty) for i in params).ToList()
    return params