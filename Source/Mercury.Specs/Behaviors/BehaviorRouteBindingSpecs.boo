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
import Msb

// associating behaviors w/ routes

// behavior re-instantiation concerns
when when_there_are_two_routes_and_one_behavior_targets_them_both_but_also_excludes_one_of_the_routes, BehaviorSpecs:
  establish:
    assembly = CompileCodeAndGetContext(code).GeneratedAssembly
    allBehaviors = List of Type()
    allBehaviors.Add(GetTypeFromAssemblyNamed(assembly, "Test.BehaviorA"))
    routeA = "route/a"
    routeB = "route/b"
  
  because_of:
    behaviorsForRouteA = startup.GetBehaviorsForRoute(routeA, allBehaviors)
    behaviorsForRouteB = startup.GetBehaviorsForRoute(routeB, allBehaviors)
  
  it "should associate the behavior with the route that was not excluded":
    behaviorsForRouteA.Count().ShouldEqual(1)
  
  it "should not associate the behavior with the route that was excluded":
    behaviorsForRouteB.Count().ShouldEqual(0)
  
  allBehaviors as List of Type
  routeA as string
  routeB as string
  behaviorsForRouteA as Type*
  behaviorsForRouteB as Type*
  code as string = """
namespace Test
import System
import System.Web.Mvc
import Mercury.Core

behavior BehaviorA:
  target "route"
  target_not "route/b"
  run_first
  before_action:
    foo = "bar"
"""

public class when_there_is_one_route_and_two_behaviors_and_one_of_those_behaviors_target_the_route(BehaviorSpecs):  
  context as Establish = def():
    assembly = CompileCodeAndGetContext(code).GeneratedAssembly
    behaviorA = GetTypeFromAssemblyNamed(assembly, "Test.BehaviorA")()
    behaviorB = GetTypeFromAssemblyNamed(assembly, "Test.BehaviorB")()
  
  of_ as Because = def():
    bleh = List of Type()
    bleh.Add(behaviorA.GetType())
    bleh.Add(behaviorB.GetType())
    behaviorTypes = startup.GetBehaviorsForRoute("foo", bleh)
  
  should_associate_one_behaviors_with_the_route as It = def():
    behaviorTypes.Count().ShouldEqual(1)
  
  static behaviorTypes as Type*
  
  static code = """
namespace Test
import System
import System.Web.Mvc
import Mercury.Core

behavior BehaviorA:
  target "foo"
  run_first
  before_action:
    foo = "bar"
  
behavior BehaviorB:
  target "bar"
  before_action:
    foo = "bar"
"""

public class when_there_are_two_behaviors_in_a_collection_of_assemblies(BehaviorSpecs):
  context as Establish = def():
    assembly = CompileCodeAndGetContext(code).GeneratedAssembly
    tempList = List of Assembly()
    tempList.Add(assembly)
    assemblies = tempList
  
  of_ as Because = def():
    behaviorTypes = startup.ParseAssembliesForBehaviors(assemblies)
  
  should_find_and_return_those_two_behaviors_in_the_collection_of_all_behaviors as It = def():
    behaviorTypes.Count().ShouldEqual(2)
  
  static behaviorTypes as Type*
  static assemblies as Assembly*
  
  code = """
namespace Test
import System
import System.Web.Mvc
import Mercury.Core

behavior BehaviorA:
  target "foo"
  run_first
  before_action:
    foo = "bar"
  
behavior BehaviorB:
  target "bar"
  before_action:
    foo = "bar"
"""
  
public class when_there_are_two_behaviors_associated_with_a_route_and_one_of_the_behaviors_relies_on_a_behavior_that_is_not_associated_with_the_route(BehaviorSpecs):
  context as Establish = def():
    assembly = CompileCodeAndGetContext(code).GeneratedAssembly
    tempList = List of Assembly()
    tempList.Add(assembly)
    assemblies = tempList
    behaviorTypes = List of Type()
    behaviorTypes.Add(GetTypeFromAssemblyNamed(assembly, "Test.BehaviorA"))
    behaviorTypes.Add(GetTypeFromAssemblyNamed(assembly, "Test.BehaviorB"))
  
  of_ as Because = def():
    exception = Catch.Exception:
      behaviorTypes = startup.GetBehaviorsForRoute("foo", behaviorTypes)
  
  should_cause_an_error as It = def():
    exception.ShouldNotBeNull()
  
  static behaviorTypes as List of Type
  static assemblies as Assembly*
  
  code = """
namespace Test
import System
import System.Web.Mvc
import Mercury.Core

behavior BehaviorA:
  target "foo"
  run_after BehaviorB
  before_action:
    foo = "bar"
  
behavior BehaviorB:
  target "bar"
  before_action:
    foo = "bar"
"""