
namespace Mercury.ExampleSite

import System
import System.Collections.Generic
import System.Linq
import System.Web
import System.Web.Mvc
import System.Web.Routing
import Spark.Web.Mvc
import Mercury.Core
import Machine.Container
import Microsoft.Practices.ServiceLocation

import System.Web.Mvc.RouteCollectionExtensions from System.Web.Mvc

// Note: For instructions on enabling IIS6 or IIS7 classic mode, 
// visit http://go.microsoft.com/?LinkId=9394801

public class MercuryApplication(System.Web.HttpApplication):

	
	public static def ConfigureMercuryEngine(container as IServiceLocator) as IEnumerable[of Route]:
		engine  = MercuryStartupService(container, ViewEngines.Engines)
		return engine.BuildRoutes()
		/*routes.MapRoute(
          "Default",                                              // Route name
          "{controller}/{action}/{id}",                           // URL with parameters
          new { controller = "Home", action = "Index", id = "" }  // Parameter defaults
      );*/
		

	
	protected def Application_Start():
		container = ConfigureContainer()
		routes = ConfigureMercuryEngine(container)
		
		RouteTable.Routes.IgnoreRoute('{resource}.axd/{*pathInfo}')
		for route in routes:
			RouteTable.Routes.Add(route.Url, route)
		ViewEngines.Engines.Add(SparkViewFactory())

	
	protected static def ConfigureContainer() as IServiceLocator:
		container = MachineContainer()
		return CommonServiceLocatorAdapter(container)

