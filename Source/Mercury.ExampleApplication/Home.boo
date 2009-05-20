namespace Mercury.ExampleApplication

import System
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

Get "/":
  dependency testService as ITestService
  ViewData["todaysDate"] = DateTime.Now.Date
  ViewData["testMessage"] = testService.GetSomeString()  
  ViewData["anotherMessage"] = "another message!";
  ViewData["hello"] = (TempData["hello"] if TempData.ContainsKey("hello") else string.Empty)
  spark "Home/Index.spark"
  

Get "user/{username}/{password}":
  dependency testService as ITestService
  view.todaysDate = DateTime.Now.Date
  view.testMessage = testService.GetSomeString()  
  view.anotherMessage = 'User: ' + username + " Password: " + password
  view.hello = (TempData["hello"] if TempData.ContainsKey("hello") else string.Empty)
  spark "Home/Nested/UserInfo.spark"

Behavior FailingBefore:
  target "behavior/fails/before"
  before_action:
    return "failing before action!"

Get "behavior/fails/before":
  dependency testService as ITestService
  ViewData["todaysDate"] = DateTime.Now.Date
  ViewData["testMessage"] = testService.GetSomeString()  
  ViewData["anotherMessage"] = "another message!";
  ViewData["hello"] = (TempData["hello"] if TempData.ContainsKey("hello") else string.Empty)
  spark "Home/Index.spark"

Behavior FailingAfter:
  target "behavior/fails/after"
  after_action:
    return "failing after action!"

Get "behavior/fails/after":
  dependency testService as ITestService
  ViewData["todaysDate"] = DateTime.Now.Date
  ViewData["testMessage"] = testService.GetSomeString()  
  ViewData["anotherMessage"] = "another message!";
  ViewData["hello"] = (TempData["hello"] if TempData.ContainsKey("hello") else string.Empty)
  spark "Home/Index.spark"

Get "Return/Json":
  foo = (1, 2, 3)
  json foo

Get "error/403":
  halt 403

Get "error/500":
  halt 500, "the db has gone to lunch"

Get "error/500sub":
  halt 500.1

Get "redirect/user":
  redirect "/user/baz/42"

Behavior TargetsNotFound:
  target "not_found"
  before_action:
    request.Controller.ViewData["notFoundMessage"] = "this is a not found message."

not_found:
  view.url = url
  spark "Error/NotFound.spark"

Behavior SetNHamlMasterPath:
  target "nhaml"
  before_action:
    request.Controller.ViewData["nhamlMasterName"] = "layouts/Application.haml"

Get "views/nhaml/hw":
  view.hw = "Hello world from NHaml!"
  nhaml "Index.haml"
  