namespace Mercury.Routing

import System
import System.Web
import System.Security.Permissions
import System.Linq.Enumerable from System.Core
import System.Collections.Generic
import Mercury.Core

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
   
   public static def CreateNodeIfItDoesntExistAndReturnTarget(parentNode as IRouteNode, targetNode as IRouteNode) as IRouteNode:
     if targetNode.IsParameter:
       parentNode.Nodes.Add(targetNode.Name, targetNode) if not parentNode.HasParameterChildNode
       return parentNode.ParameterChildNode
     else:
       parentNode.Nodes.Add(targetNode.Name, targetNode) if not parentNode.Nodes.ContainsKey(targetNode.Name)
       return parentNode.Nodes[targetNode.Name]
   
   public static def GetFirstRouteMatchingRequestUrl(method as string, routeString as string) as RouteData:
     splitChar = '/'.ToCharArray()
     routeParts = routeString.Split(splitChar, StringSplitOptions.RemoveEmptyEntries) as string*
     
     currentNode = Root
     handler as MercuryRouteHandler = null
     values = Dictionary[of string, string]()
     for part in routeParts:
       if currentNode.ContainsNonParameterNodeNamed(part):
         currentNode = currentNode.Nodes[part]
         if part.Equals(routeParts.Last()) and currentNode.HasAtLeastOneHandler:
           handler = GetHandlerIfLastNodeInRouteString(currentNode, part, method)
       elif currentNode.HasParameterChildNode:
         currentNode = currentNode.ParameterChildNode
         if part.Equals(routeParts.Last()) and currentNode.HasAtLeastOneHandler:
           handler = GetHandlerIfLastNodeInRouteString(currentNode, part, method)
       else:
         break
      return RouteData(values, handler)
   
   public static def GetHandlerIfLastNodeInRouteString(currentNode as IRouteNode, part as string, method as string):
     handler as MercuryRouteHandler = null
     for handlerInNode in currentNode.Handlers:
       if method.Equals(handlerInNode.RouteSpecification.HttpMethod):
         handler = handlerInNode
         break
     return handler
   
   public static def Flush():
     _root = RootRouteNode()