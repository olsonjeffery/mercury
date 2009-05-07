namespace Mercury.Specs

import System
import System.Collections.Generic
import Machine.Specifications
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Machine.Specifications.NUnitShouldExtensionMethods from Machine.Specifications.NUnit
import System.Linq.Enumerable from System.Core
import Mercury.Core
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

public class RouteResultProcessingSpecs(CommonSpecBase):
  context as Establish = def():
    resultProcessor = Rhino.Mocks.MockRepository.GenerateMock[of RouteResultProcessor]()
      
  protected static processNullResult = def(resultProcessor as RouteResultProcessor):
    resultProcessor.ProcessNullResult()
  
  protected static processNullStub = def(resultProcessor as RouteResultProcessor):
    resultProcessor.ProcessNullResult()
  
  protected static resultProcessor as RouteResultProcessor
  protected static requestContext as RequestContext
  protected static routeAction as Mercury.Core.MercuryControllerBase