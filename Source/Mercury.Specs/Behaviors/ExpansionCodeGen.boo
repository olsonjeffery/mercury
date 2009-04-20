namespace Mercury.Specs.Behaviors

import System
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Machine.Specifications
import Machine.Specifications.NUnitShouldExtensionMethods from Machine.Specifications.NUnit
import Mercury.Core
import System.Linq.Enumerable from System.Core

// code generation (expansion time)
public class when_specifying_a_behavior_that_has_something_besides_a_safe_reference_identifier_for_a_name(BehaviorSpecs):
  context as Establish = def():
    macro = BehaviorMacroWithAStringForItsName()
  
  of_ as Because = def():
    exception = Catch.Exception:
      behaviorMacro.Expand(macro)
  
  should_result_in_an_exception as It = def():
    (exception isa ArgumentException).ShouldBeTrue()

public class when_specifying_a_behavior_that_does_not_have_a_target(BehaviorSpecs):
  context as Establish = def():
    macro = BehaviorMacroWithNoTarget()
  
  of_ as Because = def():
    exception = Catch.Exception:
      behaviorBuilder.BuildBehaviorClass(null, macro.Arguments[0].ToString(), macro.Body)
  
  should_result_in_an_exception as It = def():
    (exception isa NoTargetException).ShouldBeTrue()

public class when_specifying_a_behavior_target_whose_sole_argument_is_not_an_inline_reguarlar_expression_or_a_string(BehaviorSpecs):
  
  context as Establish = def():
    macro = TargetMacroWithAReferenceExpressionArgument()
  
  of_ as Because = def():
    exception = Catch.Exception:
      targetMacro.Expand(macro)
  
  should_result_in_an_exception  as It = def():
    (exception isa ArgumentException).ShouldBeTrue()
  
  should_raise_the_exception_as_a_result_of_there_being_an_improper_argument as It = def():
    exception.Message.Contains("must be a regular expression or a string").ShouldBeTrue();

public class when_a_behavior_definition_contains_a_single_dependency_declaration(BehaviorSpecs):
  context as Establish = def():
    macro = BehaviorMacroWithASingleDependency()
  
  of_ as Because = def():
    classDef = behaviorBuilder.BuildBehaviorClass(null, macro.Arguments[0].ToCodeString(), macro.Body)
  
  should_add_the_dependency_as_constructor_arguments_to_the_generated_class_definition as It = def():
    (classDef.Members.Where(memberIsAConstructor).Last() as Constructor).Parameters.Count.ShouldEqual(1)

public class when_a_behavior_definition_does_not_contain_a_before_or_after_action_block(BehaviorSpecs):
  
  context as Establish = def():
    macro = BehaviorMacroWithNoBeforeOrAfterActionBlock()
  
  of_ as Because = def():
    exception = Catch.Exception:
      behaviorBuilder.BuildBehaviorClass(null, macro.Arguments[0].ToString(), macro.Body)
  
  should_result_in_an_exception as It = def():
    (exception isa BehaviorHasNoBeforeOrAfterAfterSegmentException).ShouldBeTrue()

public class when_a_behavior_definition_contains_more_than_one_before_action_block(BehaviorSpecs):
  
  context as Establish = def():
    macro = BehaviorMacroWithTwoBeforeActionSegments()
  
  of_ as Because = def():
    exception = Catch.Exception:
      behaviorBuilder.BuildBehaviorClass(null, macro.Arguments[0].ToString(), macro.Body)
  
  should_result_in_an_exception as It = def():
    (exception isa BehaviorHasMoreThanOneBeforeActionSegmentException).ShouldBeTrue()

public class when_a_behavior_definition_contains_more_than_one_after_action_block(BehaviorSpecs):
  
  context as Establish = def():
    macro = BehaviorMacroWithTwoAfterActionSegments()
  
  of_ as Because = def():
    exception = Catch.Exception:
      behaviorBuilder.BuildBehaviorClass(null, macro.Arguments[0].ToString(), macro.Body)
  
  should_result_in_an_exception as It = def():
    (exception isa BehaviorHasMoreThanOneAfterActionSegmentException).ShouldBeTrue()

public class when_examining_a_compiled_type_for_a_behavior(BehaviorSpecs):
  context as Establish = def():
    behaviorCode = """
namespace Test
import System
import System.Web.Mvc
import Mercury.Core

behavior FooBehavior:
  target "bar"
  target /foo/
  dependency someString as string
  run_before AnotherBehavior
  before_action:
    foo = "bar"
  after_action:
    foo = "bar"
"""
  
  of_ as Because = def():
    behaviorType = CompileCodeAndGetTypeNamed(behaviorCode, "Test.FooBehavior")
    behaviorInstance = behaviorType()
  
  should_be_named_Test_FooBehavior as It = def():
    behaviorType.FullName.ShouldEqual("Test.FooBehavior")
    
  should_have_two_targets as It = def():
    behaviorInstance.Targets.Count.ShouldEqual(2)
    
  should_only_contain_targets_containing_the_text_foo_and_bar as It = def():
    (behaviorInstance.Targets as IEnumerable[of string]).Where(valuesAreEitherFooOrBar).Count().ShouldEqual(2)
  
  should_have_a_before_action_member_that_is_not_null as It = def():
    behaviorInstance.BeforeAction.ShouldNotBeNull()
  
  should_have_an_after_action_member_that_is_not_null as It = def():
    behaviorInstance.AfterAction.ShouldNotBeNull()
    
  should_have_a_single_precedence_rule as It = def():
    behaviorInstance.PrecedenceRules.Count.ShouldEqual(1)
    
  should_have_a_precedence_rule_indicating_that_it_is_a_runs_before_rule as It = def():
    behaviorInstance.PrecedenceRules[0].Precedence.ShouldEqual(Precedence.RunBefore);
  
  should_have_a_precedence_rule_indicating_that_it_targets_AnotherBehavior as It = def():
    behaviorInstance.PrecedenceRules[0].TargetName.ShouldEqual("AnotherBehavior");
  
  static valuesAreEitherFooOrBar = { x as string | x in ("/foo/", "bar") }
  static behaviorInstance as duck
  
// order-of-precedence issues at expansion-time
public class when_a_behavior_specifies_a_runs_first_precedence_and_then_specifies_any_other_precedence_rule(BehaviorSpecs):
  context as Establish = def():
    behaviorCode = """
namespace Test
import System
import System.Web.Mvc
import Mercury.Core

behavior FooBehavior:
  target "bar"
  run_first
  run_before FooBarBehavior
  before_action:
    foo = "bar"
"""
  of_ as Because = def():
    exception = Catch.Exception:
      behaviorType = CompileCodeAndGetTypeNamed(behaviorCode, "Test.FooBehavior")

  should_not_compile as It = def():
    (exception is not null).ShouldBeTrue()

public class when_a_behavior_specifies_a_runs_last_precendence_and_then_specifies_any_other_precedence_rule(BehaviorSpecs):
  context as Establish = def():
    behaviorCode = """
namespace Test
import System
import System.Web.Mvc
import Mercury.Core

behavior FooBehavior:
  target "bar"
  run_last
  run_after FooBarBehavior
  before_action:
    foo = "bar"
"""
  of_ as Because = def():
    exception = Catch.Exception:
      behaviorType = CompileCodeAndGetTypeNamed(behaviorCode, "Test.FooBehavior")

  should_not_compile as It = def():
    (exception is not null).ShouldBeTrue()

public class when_a_behavior_specifies_a_runs_before_and_runs_after_precedence_for_the_same_behavior(BehaviorSpecs):
  context as Establish = def():
    behaviorCode = """
namespace Test
import System
import System.Web.Mvc
import Mercury.Core

behavior FooBehavior:
  target "bar"
  run_before FooBarBehavior
  run_after FooBarBehavior
  before_action:
    foo = "bar"
"""
  of_ as Because = def():
    exception = Catch.Exception:
      behaviorType = CompileCodeAndGetTypeNamed(behaviorCode, "Test.FooBehavior")

  should_not_compile as It = def():
    (exception is not null).ShouldBeTrue()
