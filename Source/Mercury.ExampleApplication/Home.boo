namespace Mercury.ExampleApplication

import System
import System.IO
import Mercury.Core
import System.Web
import System.Web.Routing
import System.Web.Mvc

Behavior SetSparkMasterName:
  target ".*"
  dependency testService as ITestService
  before_action:
    action.TempData["masterName"] = "Application"

Get "":
  //TempData["masterName"] = "Application";
  masterName as string = (TempData["masterName"] if TempData.ContainsKey("masterName") else null)
  
  dependency testService as ITestService
  ViewData["todaysDate"] = DateTime.Now.Date
  ViewData["testMessage"] = testService.GetSomeString()  
  ViewData["anotherMessage"] = "another message!";

  ControllerContext.RequestContext.RouteData.Values.Add("controller", "Home")
  viewEngineResult = ViewEngines[1].FindView(self.ControllerContext, "Index", masterName, false);
  
  viewContext = ViewContext(ControllerContext, viewEngineResult.View, ViewData, TempData)
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