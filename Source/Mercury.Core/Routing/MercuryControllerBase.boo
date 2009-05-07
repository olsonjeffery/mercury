namespace Mercury.Core

import System
import System.Collections.Generic
import System.Web.Routing
import System.Web.Mvc

public class MercuryControllerBase(ControllerBase):
  
  _behaviors as IBehavior*
  public virtual Behaviors as IBehavior*:
    get:
      return _behaviors
    set:
      _behaviors = value
  
  _routeResultProcessor as RouteResultProcessor
  
  public def constructor():
    _routeResultProcessor = RouteResultProcessor()
  
  public def constructor(resultProcessor as RouteResultProcessor):
    _routeResultProcessor = resultProcessor
  
  public def ExecuteRouteAndBehaviors(requestContext as RequestContext):
    if requestContext is null:
      raise ArgumentNullException("requestContext");
    self.Initialize(requestContext);
    
    for behavior in Behaviors:
      behavior.BeforeAction(self.ControllerContext) if behavior.BeforeAction is not null
    
    result = self.RouteBody();
    
    for behavior in Behaviors:
      behavior.AfterAction(self.ControllerContext, result) if behavior.AfterAction is not null
    
    ProcessResult(result, ControllerContext)
  
  public virtual def ProcessResult(result as object, controllerContext as ControllerContext):
    if result is null:
      _routeResultProcessor.ProcessNullResult()
    elif result isa IRouteResult:
      _routeResultProcessor.ProcessIRouteResult(result)
    elif result isa string:
      controllerContext.HttpContext.Response.Output.Write(result as string)
    else: // is JSON
      pass  // do implicit json conversion here
  
  public virtual def RouteBody() as object:
    pass