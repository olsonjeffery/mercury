namespace Mercury.ExampleApplication

import System
import System.IO
import Mercury.Core
import System.Web

Get "":
  httpContext.Response.Output.Write("hello  world!!!!")

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