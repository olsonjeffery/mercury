namespace Mercury.Specs.RoutingEngine

import System
import Msb
import Machine.Specifications
import Mercury.Routing
import Mercury.Specs
import System.Linq.Enumerable from System.Core

when "placing a series of route nodes for a route string of foo/bar into the RouteTree", PlacingRouteNodesIntoRoutingTreeSpecs:
  establish:
    routeString = "foo/bar"
    routeNodes = routeStringParser.ParseRouteString(routeString)
    routeNodes.Last().AddHandler(StubbedRouteHandler())
  
  because_of:
    routeTree.AddNodes(routeNodes)
  
  it "should create a new node for 'foo' under the root node of the RouteTree":
    routeTree.Root.Nodes.ContainsKey('foo').ShouldBeTrue()
  
  it "should create a new node for 'bar' under the node for 'foo'":
    routeTree.Root.Nodes['foo'].Nodes.ContainsKey('bar').ShouldBeTrue()
  
  it "should have a single route handler under the bar node":
    routeTree.Root.Nodes['foo'].Nodes['bar'].Handlers.Count().ShouldEqual(1)

public class PlacingRouteNodesIntoRoutingTreeSpecs(CommonSpecBase):
  context_ as Establish = def():
    routeStringParser = RouteStringParser()
    routeTree = RouteTree()
  
  protected routeString as string
  protected routeNodes as IRouteNode*
  protected routeStringParser as RouteStringParser
  protected routeTree as RouteTree