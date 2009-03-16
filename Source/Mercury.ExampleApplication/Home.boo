namespace Mercury.ExampleApplication

import System
import System.IO
import Mercury.Core
import System.Web
import System.Web.Routing
import System.Web.Mvc

Get "":
  //ControllerContext.RequestContext.HttpContext.Response.Output.Write("hello  world again!!!!")
  ControllerContext.RequestContext.RouteData.Values.Add("controller", "Home")
  viewEngineResult = ViewEngines[1].FindView(self.ControllerContext, "Index", "Application", false);
  
  foo = ""
  if viewEngineResult.SearchedLocations is not null:
    for i in viewEngineResult.SearchedLocations:
      foo += i.ToString()+"\n"
  raise foo if viewEngineResult.View is null;
  viewData = ViewDataDictionary()
  tempData = TempDataDictionary()
  viewContext = ViewContext(ControllerContext, viewEngineResult.View, viewData, tempData)
  viewEngineResult.View.Render(viewContext, ControllerContext.RequestContext.HttpContext.Response.Output)
  
  //ControllerContext.RequestContext.HttpContext.Response.Output.Write("hello  world again!!!!")
  
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