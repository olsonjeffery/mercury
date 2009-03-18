namespace Mercury.ExampleApplication

import System
import System.IO
import Mercury.Core
import System.Web
import System.Web.Routing
import System.Web.Mvc

Get "":
  viewData = ViewDataDictionary()
  tempData = TempDataDictionary()
  viewData["masterName"] = "Application";
  
  dependency testService as ITestService
  viewData["todaysDate"] = DateTime.Now.Date;
  viewData["testMessage"] = testService.GetSomeString()  

  ControllerContext.RequestContext.RouteData.Values.Add("controller", "Home")
  viewEngineResult = ViewEngines[1].FindView(self.ControllerContext, "Index", viewData["masterName"], false);
  
  viewContext = ViewContext(ControllerContext, viewEngineResult.View, viewData, tempData)
  viewEngineResult.View.Render(viewContext, ControllerContext.RequestContext.HttpContext.Response.Output)

Get "Home":
  print "hello world!!!"

Get "Home/List":
  print "arggg!"
  dependency:
    testService as ITestService
    anotherService as ITestService
  print "blah"
  

Get "Test":
  print "fail!"
  dependency testService as ITestService