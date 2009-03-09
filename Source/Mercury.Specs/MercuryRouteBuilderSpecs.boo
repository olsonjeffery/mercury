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
    typeOfString = [| typeof(string) |]
    stringTypeRef = typeOfString.Type
  
  protected static def GenerateUnparsedDependencyOn(type as Type) as Block:
    return GenerateUnparsedDependencyOn(type, "specDep_"+random.Next().ToString())
  
  protected static def GenerateUnparsedDependencyOn(type as Type, name as string) as Block:
    depMacro = DependencyMacro()
    macro = MacroStatement()
    typeRef = [| typeof($type) |]
    macro.Arguments.Add(TryCastExpression(ReferenceExpression(name), typeRef.Type))
    return depMacro.Expand(macro)
  
  protected static def GeneratedParsedDependencyOn(type as Type, name as string) as ParameterDeclaration:
    return ParameterDeclaration(name, [| typeof($type) |].Type)
  
  protected static random as Random = Random()
  protected static builder as MercuryRouteBuilder
  protected static methodBody as Block
  protected static parameters as List of ParameterDeclaration
  protected static stringTypeRef as TypeReference

public class when_parsing_dependencies_from_a_route_action_whose_method_body_contains_a_single_dependency_on_string(MercuryRouteBuilderSpecs):
  context as Establish = def():
    dependency = GenerateUnparsedDependencyOn(typeof(string))
    methodBody = [|
      $(dependency)
      foo = 1
    |]
  
  of_ as Because = def():
    parameters = builder.PullDependenciesFromMacroBody(methodBody)
  
  should_find_a_single_dependency  as It = def():
    ShouldEqual(parameters.Count,1)
  
  should_find_a_dependency_of_type_string as It = def():
    for i in parameters:
      ShouldEqual(i.Type.ToString(), typeof(string).ToString())

public class when_parsing_dependencies_from_a_route_action_whose_method_body_contains_two_dependencies_on_int_and_decimal(MercuryRouteBuilderSpecs):
  context as Establish = def():
    dependency1 = GenerateUnparsedDependencyOn(typeof(int))
    dependency2 = GenerateUnparsedDependencyOn(typeof(decimal))
    methodBody = [|
      $(dependency1)
      $(dependency2)
    |]
  
  of_ as Because = def():
    parameters = builder.PullDependenciesFromMacroBody(methodBody)
  
  should_find_two_dependencies  as It = def():
    ShouldEqual(parameters.Count,2)
  
  should_find_a_dependencies_of_either_int_or_decimal as It = def():
    for i in parameters:
      ShouldBeTrue(i.Type.ToString() in (typeof(int).ToString(), typeof(decimal).ToString()))

public class when_parsing_a_given_group_of_three_dependencies_where_two_dependencies_share_the_same_name(MercuryRouteBuilderSpecs):
  context as Establish = def():
    deps = List of ParameterDeclaration()
    deps.Add(GeneratedParsedDependencyOn(typeof(string), "dep1"))
    deps.Add(GeneratedParsedDependencyOn(typeof(int), "dep2"))
    deps.Add(GeneratedParsedDependencyOn(typeof(decimal), "dep2"))
  
  of_ as Because = def():
    exception = Catch.Exception({ builder.VerifyNoOverlappingDependencies(deps) })
  
  should_cause_an_error as It = def():
    ShouldNotBeNull(exception)
  
  static deps as List of ParameterDeclaration
  static exception as Exception