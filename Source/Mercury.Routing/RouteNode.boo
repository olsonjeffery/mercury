namespace Mercury.Routing

import System
import Mercury.Core
import System.Collections.Generic
import System.Linq.Enumerable from System.Core

public interface IRouteNode:
  Name as string:
    get
  IsParameter as bool:
    get
  Handlers as MercuryRouteHandler*:
    get
  def AddHandler(handler as MercuryRouteHandler) as void
  
  Nodes as Dictionary[of string, IRouteNode]:
    get
  
  HasParameterChildNode as bool:
    get
  
  ParameterChildNode as IRouteNode:
    get
  
  def ContainsNonParameterNodeNamed(name as string) as bool
  def HasAtLeastOneHandler() as bool

abstract class BaseRouteNode(IRouteNode):
  public virtual Name as string:
    get:
      raise "BaseRouteNode.Name needs child impl"
  
  public virtual IsParameter as bool:
    get:
      return false
  
  _nodes as Dictionary[of string, IRouteNode]
  public virtual Nodes as Dictionary[of string, IRouteNode]:
    get:
      _nodes = Dictionary[of string, IRouteNode]() if _nodes is null
      return _nodes
    set:
      _nodes = value
  
  _handlers as List of MercuryRouteHandler
  public virtual Handlers as MercuryRouteHandler*:
    get:
      InitializeHandlersIfNull()
      return _handlers
  
  def InitializeHandlersIfNull():
    _handlers = List of MercuryRouteHandler() if _handlers is null
  
  public virtual def AddHandler(handler as MercuryRouteHandler) as void:
    InitializeHandlersIfNull()
    _handlers.Add(handler)
  
  public virtual HasParameterChildNode as bool:
    get:
      for node in Nodes.Values:
        return true if node.IsParameter
      return false
  
  public virtual ParameterChildNode as IRouteNode:
    get:
      return Nodes.Values.Where({ x as IRouteNode | x.IsParameter}).Single()
  
  public virtual def ContainsNonParameterNodeNamed(name as string) as bool:
    if Nodes.ContainsKey(name):
      if not Nodes[name].IsParameter:
        return true
    return false
  
  public virtual def HasAtLeastOneHandler() as bool:
    return _handlers.Count > 0
  

public class RouteNode(BaseRouteNode):
  public def constructor(name as string):
    _name = name
  
  _name as string
  public override Name as string:
    get:
      return _name
      
public class ParameterRouteNode(BaseRouteNode):
  public def constructor(name as string):
    _name = name
  
  _name as string
  public override Name as string:
    get:
      return _name
  
  public override IsParameter as bool:
    get:
      return true

public class RootRouteNode(BaseRouteNode):
  public def constructor():
    pass
  
  public virtual Name as string:
    get:
      return "Root"