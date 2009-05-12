namespace Mercury.Core

import System
import System.Collections.Generic

public class ViewAndTempWrapper(IQuackFu):
  _values as IDictionary[of string, object]
  
  def constructor(values as IDictionary[of string, object]):
    _values = values
  

  public collection[index as string] as object:
    get:
      return _values[index]
    set:
      _values[index] = value
  
  public def QuackGet(parameter as string, params as (object)) as object:
    raise "'"+parameter+"' is not a member of the view or temp data!" if not _values.ContainsKey(parameter)
    return _values[parameter]
  
  public def QuackSet(parameter as string, params as (object), val as object):
    _values[parameter] = val