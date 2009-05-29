namespace Mercury.Specs.RoutingEngine

import System
import Mercury.Specs
import Mercury.Routing
import Msb

when "parsing a route for foo/bar/baz":
  it "should split the route into four nodes"
  it "should create an initial node for the root of the application"
  it "should split the rest of the nodes on the forward slash and create nodes for each"

when "parsing a route for the root of the application", ParsingRouteStringsIntoRouteTreeSpecs:
  it "should put the handler at the base of the RouteTree"

when "parsing a route that targets Foo/Bar":
  it "should break the route into three nodes"
  it "should have the first node be for the root of the application"
  it "should have the second node be for Foo"
  it "should have the third node be for Bar"
  it "should put the handler in the node for Bar"

when "parsing a route that targest Foo/Bar/{param}", ParsingRouteStringsIntoRouteTreeSpecs:
  it "should break the route into four nodes"
  it "should put the fourth node in a Parameter node underneath the node for Bar"
  
public class ParsingRouteStringsIntoRouteTreeSpecs(CommonSpecBase):
  public def constructor():
    pass  