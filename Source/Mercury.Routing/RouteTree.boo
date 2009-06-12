namespace Mercury.Routing

import System
import System.Web
import System.Security.Permissions
import System.Linq.Enumerable from System.Core

[AspNetHostingPermission(SecurityAction.LinkDemand, Level:AspNetHostingPermissionLevel.Minimal), AspNetHostingPermission(SecurityAction.InheritanceDemand, Level:AspNetHostingPermissionLevel.Minimal)]
public class RouteTree:
  public def constructor():
    pass
  
  static _root as IRouteNode
  public static Root as IRouteNode:
    get:
      _root = RootRouteNode() if _root is null
      return _root
  
  
  public static def AddNodes(nodes as IRouteNode*) as void:
    AddNodes(nodes, Root)
  
  public static def AddNodes(nodes as IRouteNode*, currentNodeInTree as IRouteNode) as void:
    firstInputNode = nodes.ElementAt(0)
    nodesAfterFirst = nodes.Where({ x as IRouteNode | not x is firstInputNode })
    if firstInputNode isa RootRouteNode and nodes.Count() > 1:
      AddNodes(nodesAfterFirst, currentNodeInTree)
    elif nodes.Count().Equals(1):
      targetNode = CreateNodeIfItDoesntExistAndReturnTarget(currentNodeInTree, firstInputNode)
      targetNode.AddHandler(firstInputNode.Handlers.First()) if not targetNode is firstInputNode
    else:
      targetNode = CreateNodeIfItDoesntExistAndReturnTarget(currentNodeInTree, firstInputNode)
      AddNodes(nodesAfterFirst, targetNode)
   
   public static def CreateNodeIfItDoesntExistAndReturnTarget(parentNode as IRouteNode, targetNode as IRouteNode):
     if targetNode.IsParameter:
       parentNode.Nodes.Add(targetNode.Name, targetNode) if not parentNode.HasParameterChildNode
       return parentNode.ParameterChildNode
     else:
       parentNode.Nodes.Add(targetNode.Name, targetNode) if not parentNode.Nodes.ContainsKey(targetNode.Name)
       return parentNode.Nodes[targetNode.Name]
   
   public static def GetRouteDataMatchingRequestUrl(method as string, routeString as string) as RouteData:
     pass
   
   public static def Flush():
     _root = RootRouteNode()