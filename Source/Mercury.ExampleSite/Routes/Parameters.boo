namespace Mercury.ExampleSite

import System
import Mercury.Core
import System.Web
import System.Web.Mvc

Get "params/{username}/{password}":
  view.todaysDate = DateTime.Now.Date
  view.testMessage = "blah"
  view.anotherMessage = 'User: ' + username + " Password: " + password
  view.hello = (TempData["hello"] if TempData.ContainsKey("hello") else string.Empty)
  spark "Home/Nested/UserInfo.spark"