namespace Mercury.Specs

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
  
  should_add_the_dependency_as_fields_to_the_generated_class_definition_in_addition_to_the_targets_field as It = def():
    classDef.Members.Where(memberIsAField).Count().ShouldEqual(2)

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
import Mercury.Core

behavior FooBehavior:
  target "bar"
  target /foo/
  dependency someString as string
  runs_before AnotherBehavior
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
    
  should_have_an_after_action_member_that_is_not_null as It
  should_have_a_dependency_field_named_someString as It
  should_have_a_single_precedence_rule as It
  should_have_a_precedence_rule_indicating_that_the_action_runs_before_AnotherBehavior as It
  
  static valuesAreEitherFooOrBar = { x as string | x in ("/foo/", "bar") }
  static behaviorInstance as duck
  
// order-of-precedence issues at expansion-time
public class when_a_behavior_specifies_a_runs_first_precedence_and_then_specifies_any_other_precedence_rule(BehaviorSpecs):
  should_result_in_an_exception as It

public class when_a_behavior_specifies_a_runs_last_precendence_and_then_specifies_any_other_precedence_rule(BehaviorSpecs):
  should_result_in_an_exception as It

public class when_a_behavior_specifies_a_runs_before_and_runs_after_precedence_for_the_same_behavior(BehaviorSpecs):
  should_result_in_an_exception as It

// determining order-of-precedence for behaviors at startup
public class when_there_are_two_specified_behaviors_targetting_the_same_route_and_behavior_a_specifies_that_it_runs_after_behavior_b(BehaviorSpecs):
  should_place_behavior_a_after_behavior_b_in_the_run_order as It

public class when_there_are_two_specified_behaviors_targetting_the_same_route_and_behavior_a_specifies_that_it_runs_before_behavior_b(BehaviorSpecs):
  should_place_behavior_a_before_behavior_b_in_the_run_order as It

public class when_there_are_three_specified_behaviors_targetting_the_same_route_and_behavior_a_specifies_that_it_runs_after_behavior_b_and_before_behavior_c(BehaviorSpecs):
  should_place_behavior_b_as_first_in_the_run_order as It
  should_place_behavior_a_as_secod_in_the_run_order as It
  should_place_behavior_c_as_third_in_the_run_order as It

// associating behaviors w/ routes

// behavior re-instantiation concerns

public class BehaviorSpecs(CommonSpecBase):
  context as Establish = def():
    behaviorMacro = BehaviorMacro()
    behaviorBuilder = BehaviorAstBuilder()
    targetMacro = TargetMacro()
  
  protected static behaviorMacro as BehaviorMacro
  protected static behaviorBuilder as BehaviorAstBuilder
  protected static exception as Exception
  protected static targetMacro as TargetMacro
  protected static macro as MacroStatement
  protected static classDef as ClassDefinition  
  protected static behaviorType as Type
  protected static behaviorCode as string
  
  protected static def BehaviorMacroWithAStringForItsName():
    macro = MacroStatement()
    macro.Arguments.Add([| "fosdfsdfsd" |])
    return macro
  
  protected static def BehaviorMacroWithNoTarget():
    macro = MacroStatement()
    macro.Arguments.Add([| BehaviorName |])
    macro.Body = [|
      before_action:
        pass
      foo = "bar"
    |]
    return macro
  
  protected static def TargetMacroWithAReferenceExpressionArgument():
    retVal = MacroStatement()
    retVal.Arguments.Add([| FooBar |]);
    retVal.Name = "target"
    return retVal
  
  protected static def BehaviorMacroWithASingleDependency():
    macro = BehaviorMacroWithNoBeforeOrAfterActionBlock()
    beforeAction = [|
      block:
        foo = "bar"
    |]
    beforeAction.Annotate("isBeforeAction", true)
    
    macro.Body.Statements.Add(beforeAction)
    return macro
  
  protected static def BehaviorMacroWithNoBeforeOrAfterActionBlock():
    retVal = MacroStatement
    macro.Arguments.Add([| BehaviorName |])
    
    target = MacroStatement()
    target.Arguments.Add([| "foo" |])
    targetResult = TargetMacro().Expand(target)
    
    dep = GenerateUnparsedDependencyOn(typeof(string), "foo")
    
    macro.Body = [|
      $targetResult
      $dep
    |]
    
    return macro
  
  protected static def BehaviorMacroWithTwoBeforeActionSegments():
    macro = BehaviorMacroWithNoBeforeOrAfterActionBlock()
    beforeAction1 = [|
      before_action:
        foo = "bar"
    |]
    beforeAction2 = [|
      before_action:
        foo = "bar"
    |]
    beforeMacro = Before_actionMacro()
    macro.Body.Statements.Add(beforeMacro.Expand(beforeAction1))
    macro.Body.Statements.Add(beforeMacro.Expand(beforeAction2))
    
    return macro
    
  protected static def BehaviorMacroWithTwoAfterActionSegments():
    macro = BehaviorMacroWithNoBeforeOrAfterActionBlock()
    afterAction1 = [|
      after_action:
        foo = "bar"
    |]
    afterAction2 = [|
      after_action:
        foo = "bar"
    |]
    afterMacro = After_actionMacro()
    macro.Body.Statements.Add(afterMacro.Expand(afterAction1))
    macro.Body.Statements.Add(afterMacro.Expand(afterAction2))
    
    return macro