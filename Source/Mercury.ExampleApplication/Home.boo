namespace Mercury.ExampleApplication

import System
import Mercury.Core
import System.Web

Get "":
  print "hi-lo!"

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