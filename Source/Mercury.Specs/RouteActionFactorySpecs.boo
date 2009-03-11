namespace Mercury.Specs

import System
import System.Collections.Generic
import System.Reflection
import System.Web
import Machine.Specifications
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Machine.Container
import Microsoft.Practices.ServiceLocation

import Machine.Specifications.NUnitShouldExtensionMethods from Machine.Specifications.NUnit

import System.Linq.Enumerable from System.Core

import Mercury.Core

public class when_picking_a_constructor_to_instantiate_a_route_action_from_and_there_is_a_single_paramless_constructor(RouteActionFactorySpecs):
  
  of_ as Because = def():
    ctor = factory.GetConstructorWithMostParametersFor(singleCtorRouteActionType)
  
  should_pick_the_only_available_constructor_with_zero_parameters as It = def():
    (List of ParameterInfo(ctor.GetParameters())).Count.ShouldEqual(0)

public class when_picking_a_constructor_to_instantiate_a_route_action_from_and_there_are_multiple_constructors(RouteActionFactorySpecs):
  
  of_ as Because = def():
    ctor = factory.GetConstructorWithMostParametersFor(multipleCtorRouteActionType)
  
  should_pick_the_constructor_with_the_most_parameters as It = def():
    (List of ParameterInfo(ctor.GetParameters())).Count.ShouldEqual(1)

public class when_searching_for_dependencies_for_a_route_action_and_the_container_cannot_satisfy_them_all(RouteActionFactorySpecs):
  should_raise_an_exception as It
  should_indicate_the_route_with_the_unsatisfied_dependency_in_the_exception_message as It

public class when_searching_for_dependencies_for_a_route_action_with_two_dependencies_and_the_container_has_all_of_them(RouteActionFactorySpecs):
  should_return_two_dependencies as It
  should_return_dependencies_matching_the_types_in_the_route_action_types_chosen_constructor as It

public class RouteActionFactorySpecs:
  
  context as Establish = def():
    container = MachineContainer()
    serviceLocator = CommonServiceLocatorAdapter(container)
    factory = RouteActionFactory(serviceLocator)
    singleCtorRouteActionType = typeof(SingleCtorRouteAction)
    multipleCtorRouteActionType = typeof(MultipleCtorRouteAction)
  
  protected static factory as RouteActionFactory
  protected static container as MachineContainer
  protected static serviceLocator as IServiceLocator
  protected static singleCtorRouteActionType as Type
  protected static multipleCtorRouteActionType as Type
  protected static ctor as ConstructorInfo

public class MultipleCtorRouteAction(IMercuryRouteAction):
  public def constructor():
    pass
  
  public def constructor(foo as ITestService):
    _foo = foo
  
  public def Execute():
    pass
  
  public HttpMethod as string:
    get:
      return "POST"
  
  public RouteString as string:
    get:
      return "multiple/ctor"
  
  _foo as ITestService
  
  [property(HttpContext)]
  public _httpContext as HttpContext

public class SingleCtorRouteAction(IMercuryRouteAction):
  public def constructor():
    pass
  
  public def Execute():
    pass
  
  public HttpMethod as string:
    get:
      return "GET"
  
  public RouteString as string:
    get:
      return "single/ctor"
  
  [property(HttpContext)]
  public _httpContext as HttpContext

public class ITestService:
  def constructor():
    pass
  
  def HellWorld() as string:
    return "hello world!"