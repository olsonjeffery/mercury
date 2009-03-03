namespace MvcApplication1

import System;
import System.Collections.Generic;
import System.Web;
import System.Web.Mvc;
import System.Web.Routing;
import Mercury.ExampleSite;

public class MvcApplication(System.Web.HttpApplication):
	public def constructor():
		pass
	
	public static def RegisterRoutes(routes as RouteCollection) as void:
		RouteCollectionExtensions.IgnoreRoute(routes, "{resource}.axd/{*pathInfo}")
		RouteCollectionExtensions.MapRoute(routes, "Default", "{controller}/{action}/{id}", RouteInfo("Home","Index",""))

	protected def Application_Start() as void:
		RegisterRoutes(RouteTable.Routes);
