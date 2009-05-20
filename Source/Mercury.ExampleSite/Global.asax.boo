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
import Mercury.ExampleSite.Domain

import System.Web.Mvc.RouteCollectionExtensions from System.Web.Mvc

public class MercuryApplication(System.Web.HttpApplication):  
  public static def ConfigureMercuryEngine() as IEnumerable[of Route]:
    viewEngines = ConfigureViewEngines()
    container = ConfigureContainer()
    engine = MercuryStartupService(container, viewEngines)
    routes = engine.BuildRoutes()
    
    RouteTable.Routes.IgnoreRoute("{resource}.axd/{*pathInfo}")
    for route in routes:
      RouteTable.Routes.Add(route.Url, route)
    return routes
  
  protected def Application_Start():
    ConfigureMercuryEngine()
  
  protected static def ConfigureContainer() as IServiceLocator:
    container = MachineContainer()
    container.Initialize()
    container.PrepareForServices()
    container.Add[of TestService]()
    container.Start()
    return CommonServiceLocatorAdapter(container)
  
  protected static def ConfigureViewEngines() as ViewEngineCollection:
    ViewEngines.Engines.Add(SparkViewFactory())
    ViewEngines.Engines.Add(MercuryNHamlViewEngine())
    return ViewEngines.Engines
