namespace Mercury.ExampleSite.Routes

import System
import Mercury.Core
import System.Web
import System.Web.Mvc

Behavior SetNHamlMasterPath:
  target "nhaml"
  before_action:
    request.Controller.ViewData["nhamlMasterName"] = "layouts/Application.haml"

Get "views/nhaml/hw":
  view.hw = "Hello world from NHaml!"
  nhaml "Index.haml"