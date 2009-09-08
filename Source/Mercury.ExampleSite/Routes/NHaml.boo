namespace Mercury.ExampleSite.Routes

import System
import Mercury.Core
import System.Web
import System.Web.Mvc

Behavior SetNHamlMasterPath:
  target "nhaml"
  before_action:
    request.Controller.ViewData["nhamlMasterName"] = "NHaml/Layouts/Application.haml"

Get "nhaml":
  view.hw = "Hello world from NHaml!"
  nhaml "NHaml/Index.haml"

Get "nhaml/noextension":
  view.hw = "hello world from extensionless nhaml!"
  nhaml "NHaml/Index"
