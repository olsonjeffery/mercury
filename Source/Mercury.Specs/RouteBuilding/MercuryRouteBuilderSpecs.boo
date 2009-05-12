namespace Mercury.Specs

import System
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Msb
import Machine.Specifications
import Boo.Lang.Builtins
import System.Linq.Enumerable from System.Core
import Mercury.Core

when "when defining a route with a parameter named foo", MercuryRouteBuilderSpecs:
  establish:
    inputMethod = Method()
    route = "test/{foo}"
    
  because_of:
    resultMethod = builder.DoTransformationsOnRouteBody(inputMethod, route, excludeList)
  
  it "should add a local variable named foo to the RouteBody at expansion time":
    resultMethod.Body.Statements[3].ToCodeString().Trim().ShouldEqual("foo as string = params.QuackGet('foo', null)")
  
  inputMethod as Method
  resultMethod as Method
  route as string
  excludeList as List of ParameterDeclaration = List of ParameterDeclaration()

when attempting_to_add_dependencies_to_a_route_actions_constructor_and_there_are_no_dependencies, MercuryRouteBuilderSpecs:
  establish:
    classDefinition = [|
      public class foo:
        public def constructor():
          pass
    |]
    deps = List of ParameterDeclaration()
  
  because_of:
    classDefintion = builder.PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDefinition, deps)
  
  it "should not create an additional constructor":
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

public class when_there_is_a_route_which_consists_solely_of_a_single_forward_slash_to_indicate_that_its_the_route_for_the_root_page(MercuryRouteBuilderSpecs):
  context as Establish = def():
    assembly = CompileCodeAndGetContext(code).GeneratedAssembly
    route = GetTypeFromAssemblyThatImplements(assembly, typeof(IMercuryRouteAction))() as IMercuryRouteAction
    routeString = route.RouteString
  
  should_change_the_route_to_an_empty_string as It = def():
    routeString.ShouldEqual(string.Empty)
    
  routeString as string
  macro as MacroStatement
  
  code = """
namespace Test
import System
import System.Web
import System.Web.Mvc
import Mercury.Core

Get "/":
  pass
"""

public class MercuryRouteBuilderSpecs(CommonSpecBase):
  context as Establish = def():
    builder = MercuryRouteAstBuilder()
    typeOfString = [| typeof(string) |]
    stringTypeRef = typeOfString.Type
    
  protected static random as Random = Random()
  protected static builder as MercuryRouteAstBuilder
  protected static deps as ParameterDeclaration*
  protected static classDefinition as ClassDefinition
  protected static depsList as List of ParameterDeclaration