namespace Mercury.Core.Routing

import System
import System.Web
import System.Web.Routing

class MercuryRoute(RouteBase):
"""Description of MercuryRoute"""
  def constructor():
    pass
  public def GetRouteData(httpContext as HttpContextBase) as RouteData:
    raise 'method: '+ httpContext.Request.HttpMethod +' url: ' + httpContext.Request.Url
  
  public def GetVirtualPath(requestContext as RequestContext, routeValueDictionary as RouteValueDictionary) as VirtualPathData:
    raise "fuck!"