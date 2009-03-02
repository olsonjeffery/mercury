namespace MvcApplication1

import System.Web;
import System.Web.Mvc;
import System.Web.UI;

public partial class _Default(Page):
	public def Page_Load(sender as object, e as System.EventArgs) as void:
    	HttpContext.Current.RewritePath(Request.ApplicationPath, false);
    	httpHandler as IHttpHandler = MvcHttpHandler();
    	httpHandler.ProcessRequest(HttpContext.Current);