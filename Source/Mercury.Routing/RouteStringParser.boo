namespace Mercury.Routing

import System
import System.Collections.Generic
import System.Linq.Enumerable from System.Core
import System.Text.RegularExpressions

public class RouteStringParser:
  public def constructor():
    pass
  
  public virtual def ParseRouteString(route as string) as IRouteNode*:
    args = "/".ToCharArray()
    splitRoute = route.Split(args, StringSplitOptions.RemoveEmptyEntries)
    
    nodes as List[of IRouteNode]
    if args.Length.Equals(0):
      nodes = ProcessForRootNode()
    else:
      nodes = ProcessRouteStringIntoNodes(splitRoute)
      nodes.Insert(0, RootRouteNode())
    
    return nodes
    
  public virtual def ProcessForRootNode():
    nodes = List of IRouteNode()
    nodes.Add(RootRouteNode())
    return nodes
  
  matchOnParameter = /^\{[^\}]+\}$/
  matchOnRegularNode = /^\w+$/
  matchOnCurlyBraces = /(\{|\})/
  
  public virtual def ProcessRouteStringIntoNodes(splitRoute as (string)):
    nodes = List of IRouteNode()
    for i in splitRoute:
      node as IRouteNode
      node = ProcessParameterNode(i) if matchOnParameter.IsMatch(i)
      node = ProcessRegularNode(i) if matchOnRegularNode.IsMatch(i)
      nodes.Add(node)
    return nodes
  
  public virtual def ProcessParameterNode(i as string):
    return ParameterRouteNode(matchOnCurlyBraces.Replace(i, string.Empty))
  
  public virtual def ProcessRegularNode(i as string):
    return RouteNode(i)