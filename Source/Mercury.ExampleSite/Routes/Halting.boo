namespace Mercury.ExampleSite.Routes

import System
import Mercury.Core
import System.Web
import System.Web.Mvc

Get "error/403":
  halt 403

Get "error/500/message":
  halt 500, "the db has gone to lunch"

Get "error/500/substatus":
  halt 500.1