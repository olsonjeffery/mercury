namespace Mercury.Core

import System
import System.Collections.Generic
import System.Web.Routing
import System.Web.Mvc

public class MercuryControllerBase(ControllerBase):
  [Property(Behaviors)]
  _behaviors as IBehavior*
  
  public override def Execute(requestContext as RequestContext):
    if requestContext is null:
      raise ArgumentNullException("requestContext");
    self.Initialize(requestContext);
    
    for behavior in _behaviors:
      behavior.BeforeAction(self.ControllerContext) if behavior.BeforeAction is not null
    
    self.ExecuteCore();
    
    for behavior in _behaviors:
      behavior.AfterAction(self.ControllerContext) if behavior.AfterAction is not null