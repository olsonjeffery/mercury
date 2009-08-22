namespace Mercury.Core

import System
import System.Text.RegularExpressions

public class RouteValidator:
  public def constructor():
    pass
  
  _firstCharacterIsNonWordItem = /^\W/
  _entireRouteIsWellFormedParamter = /^\{.+\}$/
  public virtual def Validate(route as string) as bool:
    if not _entireRouteIsWellFormedParamter.IsMatch(route):
      if _firstCharacterIsNonWordItem.IsMatch(route):
        raise FormatException("Invalid first character for route '"+route+"'. A route cannot start with a non-letter/number character or any special characters such as '/' or '~'") unless route == "/"
    splitChar = "/".ToCharArray()
    nodes = route.Split(splitChar, StringSplitOptions.RemoveEmptyEntries)
    for i in nodes:
      ValidateNode(i)
  
  public virtual def ValidateNode(node as string):
    pass