namespace Mercury.Specs.RouteBuilding

import System
import Machine.Specifications
import Msb
import Mercury.Core
import Mercury.Specs

when "parsing a route that consists of solely a parameter that is well formed", ValidatingTheRouteStringAtExapansionTimeSpecs:
  establish:
    routeString = "{*param}"
  
  because_of:
    exception = Catch.Exception:
      validator.Validate(routeString)
  
  it "should not fail":
    exception.ShouldBeNull()

when "parsing a route that does not consist of solely a parameter that begins with a non-word character", ValidatingTheRouteStringAtExapansionTimeSpecs:
  establish:
    routeString = "/foo/bar"
  
  because_of:
    exception = Catch.Exception:
      validator.Validate(routeString)
  
  it "should fail indicating an invalid format for the first character":
    exception.ShouldBeOfType(FormatException)

public class ValidatingTheRouteStringAtExapansionTimeSpecs(CommonSpecBase):
  _context as Establish = def():
    validator = RouteValidator()
  
  routeString as string
  validator as RouteValidator
  exception as Exception