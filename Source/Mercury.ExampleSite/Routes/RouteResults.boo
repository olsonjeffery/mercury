namespace Mercury.ExampleSite.Routes

import System
import Mercury.Core
import System.Web
import System.Web.Mvc

Get "return/json":
  foo = (1, 2, 3)
  json foo

Get "redirect/user":
  redirect "/user/baz/42"