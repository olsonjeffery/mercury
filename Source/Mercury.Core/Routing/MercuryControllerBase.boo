namespace Mercury.Core

import System
import System.Collections.Generic
import System.Web.Routing
import System.Web.Mvc

public class MercuryControllerBase(ControllerBase):
  [Property(Behaviors)]
  _behaviors as IBehavior*
  
  _routeResultProcessor as RouteResultProcessor
  
  public def constructor():
    _routeResultProcessor = RouteResultProcessor()
  
  public def ExecuteRouteAndBehaviors(requestContext as RequestContext):
    if requestContext is null:
      raise ArgumentNullException("requestContext");
    self.Initialize(requestContext);
    
    for behavior in _behaviors:
      behavior.BeforeAction(self.ControllerContext) if behavior.BeforeAction is not null
    
    result = self.RouteBody();
    
    for behavior in _behaviors:
      behavior.AfterAction(self.ControllerContext, result) if behavior.AfterAction is not null
    
    _routeResultProcessor.Process(result, ControllerContext)
  
  public virtual def RouteBody() as object:
    pass