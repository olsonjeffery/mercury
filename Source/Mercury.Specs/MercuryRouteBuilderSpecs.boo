namespace Mercury.Specs

import System
import System.Collections.Generic
import Machine.Specifications
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

import Machine.Specifications.NUnitShouldExtensionMethods from Machine.Specifications.NUnit

import System.Linq.Enumerable from System.Core

import Mercury.Core

public class when_attempting_to_add_dependencies_to_a_route_actions_constructor_and_there_are_no_dependencies(MercuryRouteBuilderSpecs):
  context as Establish = def():
    classDefinition = [|
      public class foo:
        public def constructor():
          pass
    |]
    deps = List of ParameterDeclaration()
  
  of_ as Because = def():
    classDefintion = builder.PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDefinition, deps)
  
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
  
  should_make_two_assignments_to_store_the_constructor_parameters_in_fields as It = def():
    (classDefinition.Members.Where(memberIsAConstructor).Where(constructorHasMoreThanZeroParameters).Single() as Constructor).Body.Statements.Count.ShouldEqual(2)

public class MercuryRouteBuilderSpecs:
  context as Establish = def():
    builder = MercuryRouteAstBuilder()
    typeOfString = [| typeof(string) |]
    stringTypeRef = typeOfString.Type
  
  
  
  protected static random as Random = Random()
  protected static builder as MercuryRouteAstBuilder
  protected static deps as ParameterDeclaration*
  protected static classDefinition as ClassDefinition
  protected static depsList as List of ParameterDeclaration
  
  protected static memberIsAConstructor = {member as TypeMember | member isa Constructor}
  protected static memberIsAField = { member as TypeMember | member  isa Field }
  protected static constructorHasMoreThanZeroParameters = { ctor as Constructor | ctor.Parameters.Count > 0}