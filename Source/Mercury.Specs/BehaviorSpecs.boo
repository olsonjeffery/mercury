namespace Mercury.Specs

import System
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Machine.Specifications
import Machine.Specifications.NUnitShouldExtensionMethods from Machine.Specifications.NUnit
import Mercury.Core

// code generation (expansion time)
public class when_specifying_a_behavior_that_has_something_besides_a_safe_reference_identifier_for_a_name(BehaviorSpecs):
  should_result_in_an_exception as It

public class when_specifying_a_behavior_that_does_not_have_a_target(BehaviorSpecs):
  should_result_in_an_exception as It

public class when_specifying_a_behavior_target_that_is_not_an_inline_reguarlar_expression_or_a_string(BehaviorSpecs):
  should_result_in_an_exception  as It

public class when_a_behaviors_definition_contains_dependency_a_dependency_declaration(BehaviorSpecs):
  should_add_the_dependency_as_constructor_arguments_to_the_generated_class_definition as It
  should_add_the_dependency_as_fields_to_the_generated_class_definition as It

public class when_a_behavior_definition_does_not_contain_a_before_or_after_action_block(BehaviorSpecs):
  should_result_in_an_exception as It

public class when_a_behavior_definition_contains_more_than_one_before_action_block(BehaviorSpecs):
  should_result_in_an_exception as It

public class when_a_behavior_definition_contains_more_than_one_after_action_block(BehaviorSpecs):
  should_result_in_an_exception as It

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

public class BehaviorSpecs:
  context as Establish = def():
    behaviorMacro = BehaviorMacro()
  
  protected static behaviorMacro as BehaviorMacro