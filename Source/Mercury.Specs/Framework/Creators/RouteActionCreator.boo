namespace Mercury.Specs

import System
import System.Collections.Generic
import Mercury.Core
import System.Web.Mvc

public class RouteActionCreator(FixtureService[of IMercuryRouteAction]):

  public def constructor():
    Creation = MaleableRouteAction()
  
  public def constructor(resultProcessor as RouteResultProcessor):
    RouteResultProcessor()
    Creation = MaleableRouteAction(resultProcessor)
  
  public def constructor(resultProcessor as RouteResultProcessor, behaviorResultProcessor as BehaviorResultProcessor):
    Creation = MaleableRouteAction(resultProcessor, behaviorResultProcessor)
  
  public def ThatReturnsANullResultInItsRouteActionBody() as RouteActionCreator:
    (Creation as MaleableRouteAction).RouteBodyImpl = def():
      return null
    return self
  
  public def ThatReturnsAnIRouteResultInItsRouteActionBody() as RouteActionCreator:
    routeResult = RouteResultStub.Instance()
    (Creation as MaleableRouteAction).RouteBodyImpl = def():
      return routeResult
    return self
  
  public def ThatReturnsAStringRouteActionBody(val as string) as RouteActionCreator:
    (Creation as MaleableRouteAction).RouteBodyImpl = def():
      return val
    return self
  
  public def WithBehaviors(behaviors as IBehavior*):
    (Creation as MercuryControllerBase).Behaviors = behaviors
    return self

public callable RouteBodyImpl() as object

public class MaleableRouteAction(MercuryControllerBase, IMercuryRouteAction):
  
  public def constructor():
    pass
  
  _viewEngines as ViewEngineCollection
  public ViewEngines as ViewEngineCollection:
    get:
      return _viewEngines
    set:
      _viewEngines = value
  
  public def constructor(resultProcessor as RouteResultProcessor):
    super(resultProcessor)
  
  public def constructor(resultProcessor as RouteResultProcessor, behaviorResultProcessor as BehaviorResultProcessor):
    super(resultProcessor, behaviorResultProcessor)
  
  [property(RouteBodyImpl)]
  _routeBodyImpl as RouteBodyImpl
  
  public override def RouteBody() as object:
    return RouteBodyImpl()  

public class RouteResultStub(IRouteResult):
  public static _instance as IRouteResult
  public static def Instance() as IRouteResult:
    _instance = RouteResultStub() if _instance is null
    return _instance