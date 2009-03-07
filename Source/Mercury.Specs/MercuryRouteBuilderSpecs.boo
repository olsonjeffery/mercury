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
  
  protected static def GenerateDependencyOn(type as Type) as Block:
    depMacro = DependencyMacro()
    macro = MacroStatement()
    typeRef = [| typeof($type) |]
    macro.Arguments.Add(TryCastExpression(ReferenceExpression("specDep_"+random.Next().ToString()), typeRef.Type))
    return depMacro.Expand(macro)
  
  protected static random as Random = Random()
  protected static builder as MercuryRouteBuilder
  protected static methodBody as Block
  protected static parameters as Dictionary [of string, ParameterDeclaration]
  protected static stringTypeRef as TypeReference

public class when_parsing_dependencies_from_a_route_action_whose_method_body_contains_a_single_dependency_on_string(MercuryRouteBuilderSpecs):
  context as Establish = def():
    dependency = GenerateDependencyOn(typeof(string))
    methodBody = [|
      $(dependency)
      foo = 1
    |]
  
  of_ as Because = def():
    parameters = builder.PullDependenciesFromMacroBody(methodBody)
  
  should_find_a_single_dependency  as It = def():
    ShouldEqual(parameters.Values.Count,1)
  
  should_find_a_dependency_of_type_string as It = def():
    for i in parameters.Values:
      ShouldEqual(i.Type.ToString(), typeof(string).ToString())
