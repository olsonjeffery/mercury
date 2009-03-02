namespace MvcApplication1

import System;
import System.Collections.Generic;
import System.Web;
import System.Web.Mvc;
import System.Web.Routing;

public class MvcApplication(System.Web.HttpApplication):
	public static def RegisterRoutes(routes as RouteCollection) as void:
		RouteCollectionExtensions.IgnoreRoute(routes, "{resource}.axd/{*pathInfo}")
		RouteCollectionExtensions.MapRoute(routes, "Default", "{controller}/{action}/{id}", RouteInfo("Home","Index",""))

	protected def Application_Start() as void:
		RegisterRoutes(RouteTable.Routes);

public class RouteInfo:
	public controller as string
	public action as string
	public id as string
	
	public def constructor(controllerTemp as string, actionTemp as string, idTemp as string):
		self.controller = controllerTemp;
		self.action = actionTemp;
		self.id = idTemp;