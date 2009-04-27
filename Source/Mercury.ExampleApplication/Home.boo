namespace Mercury.ExampleApplication

import System
import System.IO
import Mercury.Core
import System.Web
import System.Web.Routing
import System.Web.Mvc

Behavior SimpleBehavior:
  target ".*"
  before_action:
    request.Controller.TempData["hello"] = "They most certainly do ... Hello from SimpleBehavior!"

Behavior SetSparkMasterName:
  target ".*"
  dependency testService as ITestService
  run_last
  before_action:
    request.Controller.ViewData["masterName"] = "Application"

Get "":
  dependency testService as ITestService
  ViewData["todaysDate"] = DateTime.Now.Date
  ViewData["testMessage"] = testService.GetSomeString()  
  ViewData["anotherMessage"] = "another message!";
  ViewData["hello"] = (TempData["hello"] if TempData.ContainsKey("hello") else string.Empty)
  
  masterName as string = (ViewData["masterName"] if ViewData.ContainsKey("masterName") else null)
  ControllerContext.RequestContext.RouteData.Values.Add("controller", "Home")
  viewEngineResult = ViewEngines[1].FindView(self.ControllerContext, "Index", masterName, false)
  viewContext = ViewContext(ControllerContext, viewEngineResult.View, ViewData, TempData)
  viewEngineResult.View.Render(viewContext, ControllerContext.RequestContext.HttpContext.Response.Output)

Get "User/{username}/{password}":
  dependency testService as ITestService
  ViewData["todaysDate"] = DateTime.Now.Date
  ViewData["testMessage"] = testService.GetSomeString()  
  ViewData["anotherMessage"] = 'User: ' + ControllerContext.RouteData.Values["username"] + " Password: "+ControllerContext.RouteData.Values['password']
  ViewData["hello"] = (TempData["hello"] if TempData.ContainsKey("hello") else string.Empty)
  
  masterName as string = (ViewData["masterName"] if ViewData.ContainsKey("masterName") else null)
  ControllerContext.RequestContext.RouteData.Values.Add("controller", "Home")
  viewEngineResult = ViewEngines[1].FindView(self.ControllerContext, "Index", masterName, false)
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