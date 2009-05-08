namespace Mercury.Specs

import System
import System.IO
import System.Collections.Generic
import Machine.Specifications
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Machine.Specifications.NUnitShouldExtensionMethods from Machine.Specifications.NUnit
import System.Linq.Enumerable from System.Core
import Mercury.Core
import System.Web.Mvc
import System.Web.Routing
import Rhino.Mocks
import Rhino.Mocks.RhinoMocksExtensions from Rhino.Mocks

public class when_a_route_action_returns_null_as_a_result(RouteResultProcessingSpecs):
  context as Establish = def():
    requestContext = New.RequestContext().Creation;
    
    resultProcessor.Stub(processNullStub)
    routeAction = New.RouteAction(resultProcessor).ThatReturnsANullResultInItsRouteActionBody().Creation
  
  of_ as Because = def():
    routeAction.ExecuteRouteAndBehaviors(requestContext)
  
  should_do_nothing as It = def():
    resultProcessor.AssertWasCalled( processNullResult )     

public class when_a_route_action_returns_an_object_that_implments_IRouteResult_as_the_result(RouteResultProcessingSpecs):
  context as Establish = def():
    requestContext = New.RequestContext().Creation;
    
    routeAction = New.RouteAction(resultProcessor).ThatReturnsAnIRouteResultInItsRouteActionBody().Creation
    resultProcessor.Stub(processIRouteResult).IgnoreArguments() // .IgnoreArguments() appears to be broken.. need to file a bug on this
    
  of_ as Because = def():
    routeAction.ExecuteRouteAndBehaviors(requestContext)
  
  should_process_the_IRouteResult as It = def():
    resultProcessor.AssertWasCalled(processIRouteResult)
  
  static processIRouteResult = def(x as RouteResultProcessor):
    x.ProcessIRouteResult(RouteResultStub.Instance())

public class when_a_route_action_returns_a_string_as_the_result(RouteResultProcessingSpecs):
  context as Establish = def():
    requestContext = New.RequestContext().Creation;
    output = StreamWriter(MemoryStream())
    (requestContext.HttpContext.Response as TestHttpResponse).SetOutput(output)
    
    routeAction = New.RouteAction(resultProcessor).ThatReturnsAStringRouteActionBody(blah).Creation
    resultProcessor.Stub(processStringResult).IgnoreArguments() // .IgnoreArguments() appears to be broken.. need to file a bug on this
    
  of_ as Because = def():
    routeAction.ExecuteRouteAndBehaviors(requestContext)
  
  should_write_the_string_to_the_output as It = def():
    resultProcessor.AssertWasCalled(processStringResult)
  
  static processStringResult = def(x as RouteResultProcessor):
    x.ProcessStringResult(blah, output)
    
public class when_a_before_action_behavior_returns_a_non_null_result(RouteResultProcessingSpecs):
  context as Establish = def():
    requestContext = New.RequestContext().Creation;
    output = StreamWriter(MemoryStream())
    (requestContext.HttpContext.Response as TestHttpResponse).SetOutput(output)
    behaviors = List of IBehavior()
    behaviors.Add(New.Behavior().WithBeforeAction(beforeActionBlockThatReturnsAString).Creation)
    
    routeAction = New.RouteAction(resultProcessor, behaviorResultProcessor).ThatReturnsAStringRouteActionBody(blah).Creation
    resultProcessor.Stub(processRouteStringResult).IgnoreArguments()
    behaviorResultProcessor.Stub(processingBehaviorStringResult).IgnoreArguments()
    
  of_ as Because = def():
    routeAction.ExecuteRouteAndBehaviors(requestContext)
  
  should_not_process_the_result_from_the_route_action as It = def():
    resultProcessor.AssertWasNotCalled(processRouteStringResult)
  
  beforeActionBlockThatReturnsAString = def(c as ControllerContext):
    return blah
  
  processingBehaviorStringResult = def(x as BehaviorResultProcessor):
    x.ProcessStringResult(blah, output)
  
  static processRouteStringResult = def(x as RouteResultProcessor):
    x.ProcessStringResult(blah, output)

public class RouteResultProcessingSpecs(CommonSpecBase):
  context as Establish = def():
    resultProcessor = Rhino.Mocks.MockRepository.GenerateMock[of RouteResultProcessor]()
    behaviorResultProcessor = Rhino.Mocks.MockRepository.GenerateMock[of BehaviorResultProcessor]()
    output = StreamWriter(MemoryStream())
      
  protected static processNullResult = def(resultProcessor as RouteResultProcessor):
    resultProcessor.ProcessNullResult()
  
  protected static processNullStub = def(resultProcessor as RouteResultProcessor):
    resultProcessor.ProcessNullResult()
  
  protected static blah as string = "foo"
  protected static output as TextWriter
  protected static resultProcessor as RouteResultProcessor
  protected static behaviorResultProcessor as BehaviorResultProcessor
  protected static requestContext as RequestContext
  protected static routeAction as Mercury.Core.MercuryControllerBase