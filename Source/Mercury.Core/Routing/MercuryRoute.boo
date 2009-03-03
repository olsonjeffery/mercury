namespace Mercury.Core.Routing

import System
import System.Reflection
import System.Web
import System.Web.Routing

class MercuryRoute(RouteBase):
"""Description of MercuryRoute"""
  def constructor():
    pass
  public def GetRouteData(httpContext as HttpContextBase) as RouteData:
    blah = System.AppDomain.CurrentDomain.GetAssemblies();
    assemblyNames = "";
    for i in blah:
      assemblyNames += (i.FullName + "\n") if not i.FullName.Contains("System");
    raise 'method: '+ httpContext.Request.HttpMethod +' url: ' + httpContext.Request.Url + '\n '+ assemblyNames
  
  public def GetVirtualPath(requestContext as RequestContext, routeValueDictionary as RouteValueDictionary) as VirtualPathData:
    raise "fuck!"