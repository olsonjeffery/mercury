namespace Mercury.Specs.Behaviors

import System
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Machine.Specifications
import Machine.Specifications.NUnitShouldExtensionMethods from Machine.Specifications.NUnit
import Mercury.Core
import System.Linq.Enumerable from System.Core

// associating behaviors w/ routes

// behavior re-instantiation concerns

public class when_there_is_one_route_and_three_behaviors_and_two_behaviors_target_the_route(BehaviorSpecs):
  should_associate_two_of_the_three_behaviors_with_the_route as It