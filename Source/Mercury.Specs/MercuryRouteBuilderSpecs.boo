namespace Mercury.Specs

import System
import System.Collections.Generic
import Machine.Specifications
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
//import Machine.Specifications.NUnitCollectionExtensionMethods from Machine.Specifications
import Machine.Specifications.NUnitShouldExtensionMethods from Machine.Specifications.NUnit

import System.Linq.Enumerable from System.Core

import Mercury.Core
  
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
    ShouldEqual(parameters.Count(),1)
  
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
    ShouldEqual(parameters.Count(),2)
  
  should_find_dependencies_of_either_int_or_decimal as It = def():
    for i in parameters:
      (i.Type.ToString() in (intType, decimalType)).ShouldBeTrue()

public class when_parsing_a_given_group_of_three_dependencies_where_two_dependencies_share_the_same_name(MercuryRouteBuilderSpecs):
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

public class when_attempting_to_add_dependencies_to_a_route_actions_constructor_and_there_are_no_dependencies(MercuryRouteBuilderSpecs):
  context as Establish = def():
    classDefinition = [|
      public class foo:
        public def constructor():
          pass
    |]
    deps = List of ParameterDeclaration()
  
  of_ as Because = def():
    classDefintion = MercuryRouteBuilder().PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDefinition, deps)
  
  should_not_create_an_additional_constructor as It = def():
    classDefinition.Members.Where(memberIsAConstructor).Count().ShouldEqual(1)

public class when_attempting_to_add_dependencies_to_a_generated_route_action_class_and_there_are_two_dependencies(MercuryRouteBuilderSpecs):
  context as Establish = def():
    classDefinition = [|
      public class foo:
        public def constructor():
          pass
    |]
    depsList = List of ParameterDeclaration()
    depsList.Add(ParameterDeclaration("foo", [| typeof(string) |].Type))
    depsList.Add(ParameterDeclaration("bar", [| typeof(int) |].Type))
  
  of_ as Because = def():
    classDefintion = builder.PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDefinition, depsList)
  
  should_create_an_additional_constructor as It = def():
    classDefinition.Members.Where(memberIsAConstructor).Count().ShouldEqual(2)

  should_have_the_constructors_parameters_be_of_the_same_type_as_the_dependencies as It = def():
    for parameter in (classDefinition.Members.Where(memberIsAConstructor).ElementAt(1) as Constructor).Parameters:
      (parameter.Type.ToString() in ("string", "int")).ShouldBeTrue()
  
  should_add_two_fields_to_the_generated_class as It = def():
    classDefinition.Members.Where(memberIsAField).Count().ShouldEqual(2)
  
  should_make_the_fields_of_the_same_types_as_the_dependencies as It = def():
    for field as Field in classDefinition.Members.Where(memberIsAField):
      (field.Type.ToString() in ("string", "int")).ShouldBeTrue()
  
  should_make_the_fields_of_the_same_name_as_the_dependencies as It = def():
    for field as Field in classDefinition.Members.Where(memberIsAField):
      (field.Name in ("foo", "bar")).ShouldBeTrue()

public class when_adding_fields_to_a_route_action_and_there_are_two_dependencies(MercuryRouteBuilderSpecs):
  
  of_ as Because = def():
    classDefintion = builder.PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDefinition, depsList)
  

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
  protected static parameters as ParameterDeclaration*
  protected static stringTypeRef as TypeReference
  protected static stringType as string = typeof(string).ToString()
  protected static intType as string = typeof(int).ToString()
  protected static decimalType as string = typeof(decimal).ToString()
  protected static deps as ParameterDeclaration*
  protected static classDefinition as ClassDefinition
  protected static depsList as List of ParameterDeclaration
  
  protected static memberIsAConstructor = {member as TypeMember | member isa Constructor}
  protected static memberIsAField = { member as TypeMember | member  isa Field }