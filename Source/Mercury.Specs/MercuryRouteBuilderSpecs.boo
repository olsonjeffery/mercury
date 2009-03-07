namespace Mercury.Specs

import System
import System.Collections.Generic
import Machine.Specifications
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
//import Machine.Specifications.NUnitCollectionExtensionMethods from Machine.Specifications
import Machine.Specifications.NUnitShouldExtensionMethods from Machine.Specifications.NUnit

import Mercury.Core

public class MercuryRouteBuilderSpecs:
  context as Establish = def():
    builder = MercuryRouteBuilder()
  
  protected static builder as MercuryRouteBuilder
  protected static methodBody as Block
  protected static parameters as Dictionary [of string, ParameterDeclaration]

public class when_parsing_dependencies_from_a_route_action_whose_method_body_contains_a_single_dependency_on_string(MercuryRouteBuilderSpecs):
  context as Establish = def():
    methodBody = [|
      block:
        dependency _bs as string
        foo = "bar"
    |].Body
  
  of_ as Because = def():
    parameters = builder.PullDependenciesFromMacroBody(methodBody)
  
  should_find_a_single_dependency  as It = def():
    ShouldEqual(parameters.Values.Count,1)
  
  should_find_a_dependency_of_type_string as It

