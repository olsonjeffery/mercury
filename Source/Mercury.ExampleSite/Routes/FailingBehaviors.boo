namespace Mercury.ExampleSite.Routes

import System
import Mercury.Core
import System.Web
import System.Web.Mvc

Behavior FailingBefore:
  target "behavior/fails/before"
  before_action:
    return "failing before action!"

Get "behavior/fails/before":
  ViewData["todaysDate"] = DateTime.Now.Date
  ViewData["anotherMessage"] = "another message!";
  ViewData["hello"] = (TempData["hello"] if TempData.ContainsKey("hello") else string.Empty)
  spark "Home/Index.spark"

Behavior FailingAfter:
  target "behavior/fails/after"
  after_action:
    return "failing after action!"

Get "behavior/fails/after":
  ViewData["todaysDate"] = DateTime.Now.Date
  ViewData["testMessage"] = "no deps here, either."
  ViewData["anotherMessage"] = "another message!";
  ViewData["hello"] = (TempData["hello"] if TempData.ContainsKey("hello") else string.Empty)
  spark "Home/Index.spark"