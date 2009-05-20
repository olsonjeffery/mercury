namespace Mercury.ExampleSite.Routes

import System
import Mercury.Core
import System.Web
import System.Web.Mvc
import Mercury.ExampleSite.Domain

Get "dependency":
  dependency testService as ITestService
  ViewData["todaysDate"] = DateTime.Now.Date
  ViewData["testMessage"] = testService.GetSomeString() 
  ViewData["anotherMessage"] = "another message!"
  ViewData["hello"] = (TempData["hello"] if TempData.ContainsKey("hello") else string.Empty)
  spark "Home/Index.spark"