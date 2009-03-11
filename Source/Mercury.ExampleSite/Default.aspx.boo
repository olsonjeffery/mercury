
namespace Mercury.ExampleSite

import System.Web
import System.Web.Mvc
import System.Web.UI

partial public class _Default(Page):

	public def Page_Load(sender as object, e as System.EventArgs):
		HttpContext.Current.RewritePath(Request.ApplicationPath, false)
		httpHandler as IHttpHandler = MvcHttpHandler()
		httpHandler.ProcessRequest(HttpContext.Current)

