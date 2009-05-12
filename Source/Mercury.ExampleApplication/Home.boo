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
  

Get "User/{username}/{password}":
  dependency testService as ITestService
  view.todaysDate = DateTime.Now.Date
  view.testMessage = testService.GetSomeString()  
  view.anotherMessage = 'User: ' + username + " Password: " + password
  view.hello = (TempData["hello"] if TempData.ContainsKey("hello") else string.Empty)
  spark "Home/Nested/UserInfo.spark"

Behavior FailingBefore:
  target "Behavior/Fails/Before"
  before_action:
    return "failing before action!"

Get "Behavior/Fails/Before":
  dependency testService as ITestService
  ViewData["todaysDate"] = DateTime.Now.Date
  ViewData["testMessage"] = testService.GetSomeString()  
  ViewData["anotherMessage"] = "another message!";
  ViewData["hello"] = (TempData["hello"] if TempData.ContainsKey("hello") else string.Empty)
  spark "Home/Index.spark"

Behavior FailingAfter:
  target "Behavior/Fails/After"
  after_action:
    return "failing after action!"

Get "Behavior/Fails/After":
  dependency testService as ITestService
  ViewData["todaysDate"] = DateTime.Now.Date
  ViewData["testMessage"] = testService.GetSomeString()  
  ViewData["anotherMessage"] = "another message!";
  ViewData["hello"] = (TempData["hello"] if TempData.ContainsKey("hello") else string.Empty)
  spark "Home/Index.spark"


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