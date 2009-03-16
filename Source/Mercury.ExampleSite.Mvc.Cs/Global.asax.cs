using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Spark.Web.Mvc;
using Mercury.Core;
using Machine.Container;
using Microsoft.Practices.ServiceLocation;

namespace Mercury.ExampleSite
{
  // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
  // visit http://go.microsoft.com/?LinkId=9394801

  public class MercuryApplication : System.Web.HttpApplication
  {
    
    public static IEnumerable<Route> ConfigureMercuryEngine(IServiceLocator container, ViewEngineCollection viewEngines)
    {
      //var view = viewEngines[0].FindView(self.ControllerContext, "Home.spark", "\\Views\\Layouts\\Application.spark", false);
      
      
      var engine = new MercuryStartupService(container, viewEngines);
      return engine.BuildRoutes();
      /*routes.MapRoute(
          "Default",                                              // Route name
          "{controller}/{action}/{id}",                           // URL with parameters
          new { controller = "Home", action = "Index", id = "" }  // Parameter defaults
      );*/
    }

    protected void Application_Start()
    {
      var viewEngines = ConfigureViewEngines();
      var container = ConfigureContainer();
      var routes = ConfigureMercuryEngine(container, viewEngines);
      
      RouteTable.Routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
      foreach(var route in routes) {
        RouteTable.Routes.Add(route.Url, route);
      }
      
    }
    
    protected static IServiceLocator ConfigureContainer() {
      var container = new MachineContainer();
      return new CommonServiceLocatorAdapter(container);
    }
    
    protected static ViewEngineCollection ConfigureViewEngines() {
      ViewEngines.Engines.Add(new SparkViewFactory());
      
      return ViewEngines.Engines;
    }
  }
}