namespace Mercury.Specs.Behaviors

import System
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Machine.Specifications
import Machine.Specifications.NUnitShouldExtensionMethods from Machine.Specifications.NUnit
import Mercury.Core
import System.Linq.Enumerable from System.Core

// determining order-of-precedence for behaviors at startup
public class when_there_are_two_specified_behaviors_targetting_the_same_route_and_behavior_a_specifies_that_it_runs_after_behavior_b(BehaviorSpecs):
  context as Establish = def():
    assembly = CompileCodeAndGetContext(code).GeneratedAssembly
    behaviors = List of IBehavior()
    behaviorA = GetTypeFromAssemblyNamed(assembly, "Test.BehaviorA")()
    behaviors.Add(behaviorA)
    behaviorB = GetTypeFromAssemblyNamed(assembly, "Test.BehaviorB")()
    behaviors.Add(behaviorB)
  
  of_ as Because = def():
    sortedBehaviors = behaviorProcessor.OrderBehaviors(behaviors)
  
  should_have_two_behaviors_in_the_sorted_list as It = def():
    sortedBehaviors.Count().ShouldEqual(2)
  
  should_place_behavior_a_after_behavior_b_in_the_run_order as It = def():
    sortedBehaviors.Last().ToString().ShouldEqual(behaviorA.ToString())
  
  protected static code as string = """
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
  target /baz/
  before_action:
    foo = "bar"
"""

public class when_a_precedence_rule_specifies_that_it_must_run_before_another_behavior_that_has_not_yet_been_added_to_the_list_of_ordered_behaviors(BehaviorSpecs):
  context as Establish = def():
    rule = PrecedenceRule("SomeBehavior", Precedence.RunBefore)
    behaviors = List of IBehavior()
    behaviors.Add(AnotherBehavior())
  
  of_ as Because = def():
    behaviorLocation = rule.LocationToBeAddedToIn(behaviors)
  
  should_indicate_that_the_behavior_can_be_added_to_the_end_of_the_list_of_ordered_behaviors as It = def():
    behaviorLocation.ShouldEqual(endOfTheList)
  
  static endOfTheList = -1

public class when_a_precedence_rule_specifies_that_it_must_run_before_another_behavior_that_has_been_added_to_the_list_of_ordered_behaviors(BehaviorSpecs):
  context as Establish = def():
    rule = PrecedenceRule("AnotherBehavior", Precedence.RunBefore)
    behaviors = List of IBehavior()
    anotherBehavior = AnotherBehavior()
    behaviors.Add(anotherBehavior)
  
  of_ as Because = def():
    behaviorLocation = rule.LocationToBeAddedToIn(behaviors)
  
  should_indicate_that_the_behavior_can_be_added_to_the_list_directly_before_the_dependant_behavior as It = def():
    behaviorLocation.ShouldEqual(behaviors.IndexOf(anotherBehavior))
  
  static anotherBehavior as IBehavior

public class when_a_behavior_has_two_run_before_precedence_rules_for_two_behaviors_already_added_to_the_list_of_ordered_behaviors(BehaviorSpecs):
  context as Establish = def():
    assembly = CompileCodeAndGetContext(code).GeneratedAssembly
    behaviors = List of IBehavior()
    behaviorA = GetTypeFromAssemblyNamed(assembly, "Test.BehaviorA")()
    behaviors.Add(behaviorA)
    behaviorB = GetTypeFromAssemblyNamed(assembly, "Test.BehaviorB")()
    behaviors.Add(behaviorB)
    behaviorC = GetTypeFromAssemblyNamed(assembly, "Test.BehaviorC")()
    behaviors.Add(behaviorC)
  
  of_ as Because = def():
    sortedBehaviors = behaviorProcessor.OrderBehaviors(behaviors)
  
  should_add_the_behavior_to_the_beginning_of_the_list as It = def():
    List of IBehavior(sortedBehaviors).IndexOf(behaviorC).ShouldEqual(0)
  
  protected static code as string = """
namespace Test
import System
import System.Web.Mvc
import Mercury.Core

behavior BehaviorA:
  target "foo"
  before_action:
    foo = "bar"

behavior BehaviorB:
  target "bar"
  target /baz/
  before_action:
    foo = "bar"

behavior BehaviorC:
  target "bar"
  run_before BehaviorA
  run_before BehaviorB
  before_action:
    foo = "bar"
"""

public class when_there_are_two_specified_behaviors_targetting_the_same_route_and_behavior_b_specifies_that_it_runs_before_behavior_a(BehaviorSpecs):
  context as Establish = def():
    assembly = CompileCodeAndGetContext(code).GeneratedAssembly
    behaviors = List of IBehavior()
    behaviorA = GetTypeFromAssemblyNamed(assembly, "Test.BehaviorA")()
    behaviors.Add(behaviorA)
    behaviorB = GetTypeFromAssemblyNamed(assembly, "Test.BehaviorB")()
    behaviors.Add(behaviorB)
  
  of_ as Because = def():
    sortedBehaviors = behaviorProcessor.OrderBehaviors(behaviors)
  
  should_add_the_behavior_to_the_beginning_of_the_list as It = def():
    sortedBehaviors.First().ShouldEqual(behaviorB)
  
  protected static code as string = """
namespace Test
import System
import System.Web.Mvc
import Mercury.Core

behavior BehaviorA:
  target "foo"
  before_action:
    foo = "bar"

behavior BehaviorB:
  target "foo"
  run_before BehaviorA  
  before_action:
    foo = "bar"
"""

public class when_there_are_three_specified_behaviors_targetting_the_same_route_and_behavior_a_specifies_that_it_runs_after_behavior_b_and_before_behavior_c(BehaviorSpecs):
  context as Establish = def():
    assembly = CompileCodeAndGetContext(code).GeneratedAssembly
    behaviors = List of IBehavior()
    behaviorA = GetTypeFromAssemblyNamed(assembly, "Test.BehaviorA")()
    behaviors.Add(behaviorA)
    behaviorB = GetTypeFromAssemblyNamed(assembly, "Test.BehaviorB")()
    behaviors.Add(behaviorB)
    behaviorC = GetTypeFromAssemblyNamed(assembly, "Test.BehaviorC")()
    behaviors.Add(behaviorC)
  
  of_ as Because = def():
    sortedBehaviors = behaviorProcessor.OrderBehaviors(behaviors)
    
  should_place_behavior_b_as_first_in_the_run_order as It = def():
    sortedBehaviors.First().ToString().ShouldEqual(behaviorB.ToString())
  
  should_place_behavior_a_as_secod_in_the_run_order as It = def():
    sortedBehaviors.ElementAt(1).ToString().ShouldEqual(behaviorA.ToString())
    
  should_place_behavior_c_as_third_in_the_run_order as It = def():
    sortedBehaviors.Last().ShouldEqual(behaviorC)
  
  protected static code as string = """
namespace Test
import System
import System.Web.Mvc
import Mercury.Core

behavior BehaviorA:
  target "foo"
  run_after BehaviorB
  run_before BehaviorC
  before_action:
    foo = "bar"

behavior BehaviorB:
  target "foo"
  before_action:
    foo = "bar"

behavior BehaviorC:
  target /foo/
  before_action:
    foo = "bar"
"""