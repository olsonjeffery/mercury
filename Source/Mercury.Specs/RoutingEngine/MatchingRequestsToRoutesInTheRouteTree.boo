namespace Mercury.Specs.RoutingEngine

import System
import Mercury.Core
import Mercury.Routing
import Msb
import Machine.Specifications
import System.Collections.Generic
import System.Linq.Enumerable from System.Core

when "having a stored route with a handler for foo/bar and receiving a request for /foo/bar", MatchingRequestsToRoutesInTheRouteTree:
  establish:
    firstRoute = routeStringParser.ParseRouteString("foo/bar")
    firstRouteHandler = StubbedRouteHandler("foo/bar", "GET")
    firstRoute.Last().AddHandler(firstRouteHandler)
    routeTree.AddNodes(firstRoute)
  
  because_of:
    routeData = routeTree.GetFirstRouteMatchingRequestUrl("GET", "/foo/bar")
  
  it "should return the route handler stored in the route":
    routeData.Handler.ShouldEqual(firstRouteHandler)
    
  it "should have no parameters stored in the Values":
    routeData.Values.Values.Count.ShouldEqual(0)

when "having a stored route with a handler for foo/bar/{baz} and receiving a request for foo/bar/42", MatchingRequestsToRoutesInTheRouteTree:
  it "should return the route handler stored in the route"
  it "should have a parameter in the Values named 'baz'"
  it "should have the baz parameter have a value of '42' as a string"

when "there is a route matching foo/{bar}/baz and a route matching foo/blah/baz and receiving a request for foo/blah/baz", MatchingRequestsToRoutesInTheRouteTree:
  it "should return the route handler for the foo/blah/baz route"
  it "should have no parameters in the Values"

when "there is a route matching foo/{bar}/baz and a route matching foo/blah/baz and receiving a request for foo/barf/baz", MatchingRequestsToRoutesInTheRouteTree:
  it "should return the route handler for the foo/{bar}/baz route"
  it "should have a parameter in Values named 'bar'"
  it "should have the 'bar' parameter have a value of 'barf'"

public class MatchingRequestsToRoutesInTheRouteTree:
  context_ as Establish = def():
    routeStringParser = RouteStringParser()
    routeTree = RouteTree()
  
  handler as MercuryRouteHandler
  firstRoute as IRouteNode*
  secondRoute as IRouteNode*
  firstRouteHandler as MercuryRouteHandler
  secondRouteHandler as MercuryRouteHandler
  routeStringParser as RouteStringParser
  routeTree as RouteTree
  routeData as RouteData
  routeString as string
  method as string