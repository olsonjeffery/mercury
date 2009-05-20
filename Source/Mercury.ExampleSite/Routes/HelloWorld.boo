namespace Mercury.ExampleSite.Routes

import System
import Mercury.Core
import System.Web
import System.Web.Mvc

Behavior SimpleBehavior:
  target ".*"
  before_action:
    request.Controller.TempData["hello"] = "They most certainly do ... Hello from SimpleBehavior!"

Behavior SetSparkMasterName:
  target ".*"
  run_last
  before_action:
    request.Controller.ViewData["masterName"] = "Application"

Get "/":
  ViewData["todaysDate"] = DateTime.Now.Date
  ViewData["testMessage"] = "no deps, here"
  ViewData["anotherMessage"] = "another message!"
  ViewData["hello"] = (TempData["hello"] if TempData.ContainsKey("hello") else string.Empty)
  spark "Home/Index.spark"