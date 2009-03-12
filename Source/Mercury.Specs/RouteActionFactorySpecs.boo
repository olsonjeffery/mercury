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
  
  context as Establish = def():
    ctor = (List of ConstructorInfo(multipleCtorRouteActionType.GetConstructors()))[1]
  
  of_ as Because = def():
    exception = Catch.Exception({ factory.GetDependenciesForConstructor(ctor) })
  
  should_raise_an_exception as It = def():
    exception.ShouldNotBeNull()

public class when_searching_for_dependencies_for_a_route_action_with_one_dependency_and_the_container_has_it(RouteActionFactorySpecs):

  context as Establish = def():
    ctor = (List of ConstructorInfo(multipleCtorRouteActionType.GetConstructors()))[1]
    container.Add[of ITestService]()
    container.Start()

  of_ as Because = def():
    dependencies = factory.GetDependenciesForConstructor(ctor)

  should_return_one_dependency as It = def():
    dependencies.Count().ShouldEqual(1)

  should_return_a_dependency_of_the_same_type_as_in_the_constructor_parameter as It = def():
    dependencies.First().GetType().ToString().ShouldEqual(typeof(ITestService).ToString())

public class when_attempting_to_create_an_instance_of_a_route_action_and_the_required_dependencies_are_in_the_container(RouteActionFactorySpecs):
  
  context as Establish = def():
    container.Add[of ITestService]()
    container.Start()
  
  of_ as Because = def():
    routeAction = factory.CreateInstanceOf(multipleCtorRouteActionType)
  
  should_create_an_instance_successfully as It = def():
    routeAction.ShouldNotBeNull()
  
  should_populate_the_instance_correctly = def():
    routeAction.RouteString.Equals(actual.RouteString)
  
  routeAction as IMercuryRouteAction
  actual as IMercuryRouteAction = MultipleCtorRouteAction()

public class RouteActionFactorySpecs:
  
  context as Establish = def():
    container = MachineContainer()
    container.Initialize()
    container.PrepareForServices()
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
  protected static dependencies as object*
  protected static exception as Exception

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