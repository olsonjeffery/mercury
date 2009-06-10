namespace Mercury.Specs.RoutingEngine

import System
import Mercury.Specs
import Mercury.Routing
import Msb
import System.Linq.Enumerable from System.Core

when "parsing a route for foo/bar/baz", ParsingRouteStringsIntoRouteTreeSpecs:
  establish:
    routeString = "foo/bar/baz"
  
  because_of:
    routeNodes = RouteStringParser().ParseRouteString(routeString)
  
  it "should split the route into four nodes":
    routeNodes.Count().ShouldEqual(4)
  
  it "should create an initial node for the root of the application":
    routeNodes.ElementAt(0).GetType().ToString().ShouldEqual(typeof(RootRouteNode).ToString())
  
  it "should split the rest of the nodes on the forward slash and create nodes for each":
    routeNodes.ElementAt(1).Name.ShouldEqual('foo')
    routeNodes.ElementAt(2).Name.ShouldEqual('bar')
    routeNodes.ElementAt(3).Name.ShouldEqual('baz')

when "parsing a route for the root of the application", ParsingRouteStringsIntoRouteTreeSpecs:
  establish:
    routeString = "/"
  
  because_of:
    routeNodes = RouteStringParser().ParseRouteString(routeString)
  
  it "should have a single route for a root route":
    routeNodes.ElementAt(0).ShouldBeOfType(RootRouteNode)
    
when "parsing a route that targest Foo/{param}/Bar", ParsingRouteStringsIntoRouteTreeSpecs:
  establish:
    routeString = "Foo/{param}/Bar"
  
  because_of:
    routeNodes = RouteStringParser().ParseRouteString(routeString)
  
  it "should break the route into four nodes":
    routeNodes.Count().ShouldEqual(4)
    
  it "should have the third node be a parameter node":
    routeNodes.ElementAt(2).ShouldBeOfType(ParameterRouteNode)
  
  it "should have the third node's name be 'param'":
    routeNodes.ElementAt(2).Name.ShouldEqual('param')
  
public class ParsingRouteStringsIntoRouteTreeSpecs(CommonSpecBase):
  public def constructor():
    pass
  
  protected routeNodes as IRouteNode*
  protected routeString as string