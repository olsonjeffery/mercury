namespace Mercury.Routing

import System

public interface IRouteNode:
  Name as string:
    get
  IsParameter as string:
    get
  Handler as Mercury

public class RouteNode:
  public def constructor(name as string):
    _name = name
  
  _name as string
  public virtual Name as string:
    get:
      return _name
  
  public virtual IsParameter as bool:
    get:
      return false

public class ParameterRouteNode:
  public def constructor(name as string):
    _name = name
  
  _name as string
  public virtual Name as string:
    get:
      return _name
  
  public virtual IsParameter as bool:
    get:
      return true

public class RootRouteNode:
  public def constructor():
    pass
  
  public virtual Name as string:
    get:
      return string.Empty
  
  public virtual IsParameter as string:
    get:
      return false