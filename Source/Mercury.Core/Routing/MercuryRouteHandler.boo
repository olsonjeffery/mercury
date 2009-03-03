namespace Mercury.Core.Routing

import System
import System.Web
import System.Web.Routing

class MercuryRouteHandler(IRouteHandler):
"""Description of MercuryRouteHandler"""
  def constructor():
    pass
  
  public def GetHttpHandler(requestContext as RequestContext) as IHttpHandler:
    raise "fuck! this shit. request type: '"+requestContext.HttpContext.Request.HttpMethod+"' url: "+requestContext.HttpContext.Request.Url

