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

public class when_a_route_action_returns_null_as_a_result:
  context as Establish = def():
    requestContext = NewService.New.RequestContext().Creation;
    resultProcessor = Rhino.Mocks.MockRepository.GenerateMock[of RouteResultProcessor]()
    resultProcessor.Stub(processNullStub)
    routeAction = NewService.New.RouteAction(resultProcessor).ThatReturnsANullResultInItsRouteActionBody().Creation
  
  of_ as Because = def():
    routeAction.ExecuteRouteAndBehaviors(requestContext)
  
  should_do_nothing as It = def():
    resultProcessor.AssertWasCalled( processNullResult )      
  
  processNullResult = def(resultProcessor as RouteResultProcessor):
    resultProcessor.ProcessNullResult()
  
  processNullStub = def(resultProcessor as RouteResultProcessor):
    resultProcessor.ProcessNullResult()
  
  resultProcessor as RouteResultProcessor
  requestContext as RequestContext
  routeAction as Mercury.Core.MercuryControllerBase
  
public class RouteResulProcessingSpecs(CommonSpecBase):
"""Description of RouteResulProcessingSpecs"""
  public def constructor():
    pass

