namespace Mercury.Core

import System
import System.Collections.Generic
import System.Web.Routing
import System.Web.Mvc

public class MercuryControllerBase(ControllerBase):
  
  _behaviors as IBehavior*
  public virtual Behaviors as IBehavior*:
    get:
      return _behaviors if _behaviors is not null
      return List of IBehavior()
    set:
      _behaviors = value
  
  _routeResultProcessor as RouteResultProcessor
  _behaviorResultProcessor as BehaviorResultProcessor
  
  public def constructor():
    _routeResultProcessor = RouteResultProcessor()
    _behaviorResultProcessor = BehaviorResultProcessor()
  
  public def constructor(resultProcessor as RouteResultProcessor):
    _routeResultProcessor = resultProcessor
    _behaviorResultProcessor = BehaviorResultProcessor()
  
  public def constructor (resultProcessor as RouteResultProcessor, behaviorProcessor as BehaviorResultProcessor):
    _routeResultProcessor = resultProcessor
    _behaviorResultProcessor = behaviorProcessor
  
  _routeActionRunner as RouteActionRunner
  _defaultRouteActionRunner as RouteActionRunner = RouteActionRunner()
  public virtual RouteActionRunner:
    get:
      return _routeActionRunner if _routeActionRunner is not null
      return _defaultRouteActionRunner
    set:
      _routeActionRunner = value
  
  public def ExecuteRouteAndBehaviors(requestContext as RequestContext):
    if requestContext is null:
      raise ArgumentNullException("requestContext");
    self.Initialize(requestContext);
    
    beforeBehaviorHasResult = false
    for behavior in Behaviors:
      behaviorResult = behavior.BeforeAction(self.ControllerContext) if behavior.BeforeAction is not null
      beforeBehaviorHasResult = ProcessBehaviorResult(behaviorResult, ControllerContext)
      break if beforeBehaviorHasResult
    return if beforeBehaviorHasResult
    
    result = RouteActionRunner.RunRouteAction(self.RouteBody)
    
    afterBehaviorHasResult = false
    for behavior in Behaviors:
      behaviorResult = behavior.AfterAction(self.ControllerContext, result) if behavior.AfterAction is not null
      afterBehaviorHasResult = ProcessBehaviorResult(behaviorResult, ControllerContext)
      break if afterBehaviorHasResult
    return if afterBehaviorHasResult
    
    ProcessRouteResult(result, ControllerContext) 
  
  public virtual def ProcessBehaviorResult(result as object, controllerContext as ControllerContext) as bool:
    hasNonNullResult = false
    if result is null:
      _behaviorResultProcessor.ProcessNullResult()
    elif result isa IRouteResult:
      _behaviorResultProcessor.ProcessIRouteResult(result)
      hasNonNullResult = true
    elif result isa string:
      _behaviorResultProcessor.ProcessStringResult(result as string, controllerContext.HttpContext.Response.Output)
      hasNonNullResult = true
    else: // is JSON
      pass  // do implicit json conversion here
    return hasNonNullResult
  
  public virtual def ProcessRouteResult(result as object, controllerContext as ControllerContext) as bool:
    hasNonNullResult = false
    if result is null:
      _routeResultProcessor.ProcessNullResult()
    elif result isa IRouteResult:
      _routeResultProcessor.ProcessIRouteResult(result)
      hasNonNullResult = true
    elif result isa string:
      _routeResultProcessor.ProcessStringResult(result as string, controllerContext.HttpContext.Response.Output)
      hasNonNullResult = true
    else: // is JSON
      pass  // do implicit json conversion here
    return hasNonNullResult
    
  public virtual def RouteBody() as object:
    pass