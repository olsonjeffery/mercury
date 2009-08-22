namespace Mercury.Specs

import System
import System.Collections.Generic
import Mercury.Core
import Machine.Specifications
import Msb
import System.Linq.Enumerable from System.Core
import Boo.Lang.Builtins

when "there is a route with a single parameter called foo in it", RouteParameterNameExtractorSpecs:
  establish:
    route = "test/{foo}"
  
  because_of:
    params = routeParameterNameExtractor.GetParametersFrom(route)
  
  it "should extract one parameter":
    params.Count().ShouldEqual(1)
    
  it "should have the parameter be named foo":
    params.ElementAt(0).ShouldEqual("foo")

when "there is a route with two parameters called foo and blahParam", RouteParameterNameExtractorSpecs:
  establish:
    route = "test/{foo}/{blahParam}"
  
  because_of:
    params = routeParameterNameExtractor.GetParametersFrom(route)
  
  it "should extract two parameters":
    params.Count().ShouldEqual(2)
    
  it "should have the parameter be named foo and blahParam":
    (param in ("foo", "blahParam") for param in params).ShouldNotContain(false)

when "there is a route with a parameter that is malformed", RouteParameterNameExtractorSpecs:
  establish:
    route = "test/{foo}/{blahParam"
  
  because_of:
    exception = Catch.Exception:
      params = routeParameterNameExtractor.GetParametersFrom(route)

  it "should cause an error indicating that the parameter is messed up":
    exception.ShouldBeOfType(InvalidOperationException)
  
  exception as Exception

when "counting the number of i letters in a string with a value of ffiffi", RouteParameterNameExtractorSpecs:
  establish:
    testString = "ffiffi"
  
  because_of:
    count = routeParameterNameExtractor.NumberOfTimesCharacterOccursInString("i", testString)
  
  it "should indicate that there are two i characters in the test string":
    count.ShouldEqual(2)
  
  count as int
  testString as string

public class RouteParameterNameExtractorSpecs(CommonSpecBase):
  context as Machine.Specifications.Establish = def():
    routeParameterNameExtractor = RouteParameterNameExtractor()
  
  protected static route as string
  protected static params as string*  
  protected static routeParameterNameExtractor as RouteParameterNameExtractor