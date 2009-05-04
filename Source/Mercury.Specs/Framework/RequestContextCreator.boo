namespace Mercury.Specs

import System
import System.Web
import System.Web.Routing

public class RequestContextCreator(FixtureService[of RequestContext]):
  public def constructor(context as HttpContextBase, routeData as RouteData):
    Creation = RequestContext(context, routeData)