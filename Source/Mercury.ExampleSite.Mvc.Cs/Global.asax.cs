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
using Mercury.ExampleApplication;

namespace Mercury.ExampleSite
{
  // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
  // visit http://go.microsoft.com/?LinkId=9394801

  public class MercuryApplication : System.Web.HttpApplication
  {
    
    public static IEnumerable<Route> ConfigureMercuryEngine()
    {
      var viewEngines = ConfigureViewEngines();
      var container = ConfigureContainer();
      var engine = new MercuryStartupService(container, viewEngines);
      var routes = engine.BuildRoutes();
      
      RouteTable.Routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
      foreach(var route in routes) {
        RouteTable.Routes.Add(route.Url, route);
      }
      return routes;
    }

    protected void Application_Start()
    {
      ConfigureMercuryEngine();
    }
    
    protected static IServiceLocator ConfigureContainer() {
      var container = new MachineContainer();
      container.Initialize();
      container.PrepareForServices();
      container.Add<ITestService, TestService>();
      container.Start();
      return new CommonServiceLocatorAdapter(container);
    }
    
    protected static ViewEngineCollection ConfigureViewEngines() {
      ViewEngines.Engines.Add(new SparkViewFactory());
      
      return ViewEngines.Engines;
    }
  }
}