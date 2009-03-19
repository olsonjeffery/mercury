namespace Mercury.Specs

import System
import System.Collections.Generic
import Machine.Specifications
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

import Machine.Specifications.NUnitShouldExtensionMethods from Machine.Specifications.NUnit

import System.Linq.Enumerable from System.Core

import Mercury.Core

public class when_parsing_dependencies_from_a_method_body_that_contains_a_single_dependency_on_string(DependencyBuildingSpecs):
  context as Establish = def():
    dependency = GenerateUnparsedDependencyOn(typeof(string))
    methodBody = [|
      $(dependency)
      foo = 1
    |]
  
  of_ as Because = def():
    parameters = builder.PullDependenciesFromMacroBody(methodBody)
  
  should_find_a_single_dependency  as It = def():
    ShouldEqual(parameters.Count(),1)
  
  should_find_a_dependency_of_type_string as It = def():
    for i in parameters:
      ShouldEqual(i.Type.ToString(), typeof(string).ToString())

public class when_parsing_dependencies_from_a_method_body_that_contains_two_dependencies_on_int_and_decimal(DependencyBuildingSpecs):
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
    ShouldEqual(parameters.Count(),2)
  
  should_find_dependencies_of_either_int_or_decimal as It = def():
    for i in parameters:
      (i.Type.ToString() in (intType, decimalType)).ShouldBeTrue()

public class when_parsing_a_given_group_of_three_dependencies_where_two_dependencies_share_the_same_name(DependencyBuildingSpecs):
  context as Establish = def():
    depsList = List of ParameterDeclaration()
    depsList.Add(GeneratedParsedDependencyOn(typeof(string), "dep1"))
    depsList.Add(GeneratedParsedDependencyOn(typeof(int), "dep2"))
    depsList.Add(GeneratedParsedDependencyOn(typeof(decimal), "dep2"))
  
  of_ as Because = def():
    verificationSucceeded = builder.VerifyNoOverlappingDependencyNames(depsList)
  
  should_fail_to_verify_the_dependencies as It = def():
    verificationSucceeded.ShouldBeFalse()
  
  static verificationSucceeded as bool

public class DependencyBuildingSpecs:
  context as Establish = def():
    builder = DependencyAstBuilder()
    random = Random()
    
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
  
  protected static depsList as List of ParameterDeclaration
  protected static random as Random
  protected static builder as DependencyAstBuilder
  protected static methodBody as Block
  protected static parameters as ParameterDeclaration*
  protected static stringTypeRef as TypeReference
  protected static stringType as string = typeof(string).ToString()
  protected static intType as string = typeof(int).ToString()
  protected static decimalType as string = typeof(decimal).ToString()    