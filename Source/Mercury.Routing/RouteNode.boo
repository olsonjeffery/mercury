namespace Mercury.Routing

import System
import Mercury.Core

public interface IRouteNode:
  Name as string:
    get
  IsParameter as bool:
    get
  Handler as MercuryRouteHandler:
    get

public class RouteNode(IRouteNode):
  public def constructor(name as string):
    _name = name
  
  _name as string
  public virtual Name as string:
    get:
      return _name
  
  public virtual IsParameter as bool:
    get:
      return false

public class ParameterRouteNode(IRouteNode):
  public def constructor(name as string):
    _name = name
  
  _name as string
  public virtual Name as string:
    get:
      return _name
  
  public virtual IsParameter as bool:
    get:
      return true

public class RootRouteNode(IRouteNode):
  public def constructor():
    pass
  
  public virtual Name as string:
    get:
      return string.Empty
  
  public virtual IsParameter as bool:
    get:
      return false