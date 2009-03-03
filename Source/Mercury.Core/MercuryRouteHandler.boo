namespace Mercury.Core

import System
import System.Web
import System.Web.Routing
import System.Web.Mvc

class MercuryRouteHandler(IRouteHandler):
"""Description of MercuryRouteHandler"""
  def constructor():
    pass
  
  public def GetHttpHandler(requestContext as RequestContext) as IHttpHandler:
    raise "method: '"+requestContext.HttpContext.Request.HttpMethod+"' url: "+requestContext.HttpContext.Request.Url

