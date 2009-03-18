namespace Mercury.Core

import System
import System.Web.Routing
import System.Web.Mvc

public class MercuryControllerBase(ControllerBase):
  public override def Execute(requestContext as RequestContext):
    super.Execute(requestContext)
