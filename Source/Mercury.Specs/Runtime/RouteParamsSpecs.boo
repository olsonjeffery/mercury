namespace Mercury.Specs.Behaviors

import System
import System.Reflection
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Machine.Specifications
import Machine.Specifications.NUnitShouldExtensionMethods from Machine.Specifications.NUnit
import Mercury.Core
import System.Linq.Enumerable from System.Core

public class when_attempting_to_read_a_param_that_is_stored_in_the_params_object_by_calling_it_directly(RouteParametersSpecs):
  
  context as Establish = def():
    routeData = Dictionary[of string, object]()
    routeData["testVal"] = expected
    params = RouteParameters(routeData)
  
  of_ as Because = def():
    actual = params.testVal
  
  should_return_the_param as It = def():
    actual.ShouldEqual(expected)
  
public class when_attempting_to_Read_a_param_that_is_not_stored_in_the_params_object_by_calling_it_directly(RouteParametersSpecs):
  context as Establish = def():
    routeData = Dictionary[of string, object]()
    routeData["testVal"] = expected
    params = RouteParameters(routeData)
  
  of_ as Because = def():
    exception = Catch.Exception:
      actual = params.notAValidParam
  
  should_cause_an_error as It = def():
    exception.ShouldNotBeNull()
  
  static exception as Exception

public class RouteParametersSpecs:
  protected static params as RouteParameters
  protected static actual as string
  protected static expected = "foo"
