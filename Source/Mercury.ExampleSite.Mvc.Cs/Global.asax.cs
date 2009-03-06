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
    
    public static void ConfigureMercuryEngine(RouteCollection routes, IServiceLocator container)
    {
      routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
      
      var engine = new MercuryStartupService(container);
      engine.Initialize(routes);
      routes.Add(engine);
      
      /*routes.MapRoute(
          "Default",                                              // Route name
          "{controller}/{action}/{id}",                           // URL with parameters
          new { controller = "Home", action = "Index", id = "" }  // Parameter defaults
      );*/
    }

    protected void Application_Start()
    {
      var container = ConfigureContainer();
      ConfigureMercuryEngine(RouteTable.Routes, container);
      ViewEngines.Engines.Add(new SparkViewFactory());
    }
    
    protected static IServiceLocator ConfigureContainer() {
      var container = new MachineContainer();
      return new CommonServiceLocatorAdapter(container);
    }
  }
}