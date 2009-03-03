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
using Machine.Container.ServiceLocatorAdapter;

namespace Mercury.ExampleSite
{
  // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
  // visit http://go.microsoft.com/?LinkId=9394801

  public class MercuryApplication : System.Web.HttpApplication
  {
    public static void RegisterRoutes(RouteCollection routes)
    {
      routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
      
      var route = new MercuryEngine(GetContainer());
      routes.Add(route);
      /*routes.MapRoute(
          "Default",                                              // Route name
          "{controller}/{action}/{id}",                           // URL with parameters
          new { controller = "Home", action = "Index", id = "" }  // Parameter defaults
      );*/
    }

    protected void Application_Start()
    {
      RegisterRoutes(RouteTable.Routes);
      ViewEngines.Engines.Add(new SparkViewFactory());

    }
    
    protected static IServiceLocator GetContainer() {
      var container = new MachineContainer();
      return new MachineServiceLocator(container);
    }
  }
}