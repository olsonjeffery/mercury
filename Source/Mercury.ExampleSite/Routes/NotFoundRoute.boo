namespace Mercury.ExampleSite.Routes

import System
import Mercury.Core
import System.Web
import System.Web.Mvc

Behavior TargetsNotFound:
  target "not_found"
  before_action:
    request.Controller.ViewData["notFoundMessage"] = "this is a not found message."

not_found:
  view.url = url
  spark "Error/NotFound.spark"