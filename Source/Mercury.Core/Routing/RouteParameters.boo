namespace Mercury.Core

import System
import System.Collections.Generic

public class RouteParameters(IQuackFu):
  _values as IDictionary[of string, object]
  
  def constructor(values as IDictionary[of string, object]):
    _values = values
  

  public collection[index as string] as object:
    get:
      return _values[index]
    set:
      _values[index] = value
  
  public def QuackGet(routeParameter as string, params as (object)) as object:
    raise "'"+routeParameter+"' is not a paremeter for this route!" if not _values.ContainsKey(routeParameter)
    return _values[routeParameter]