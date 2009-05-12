namespace Mercury.Core

import System
import System.Web.Mvc
import System.Collections.Generic
import System.Linq.Enumerable from System.Core
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class MercuryRouteAstBuilder:
  private static _randomNumber as Random = Random()
  private _dependencyBuilder as DependencyAstBuilder
  private _constructorAndFieldAstBuilder as ConstructorAndFieldAstBuilder
  
  def constructor():
    _dependencyBuilder = DependencyAstBuilder()
    _constructorAndFieldAstBuilder = ConstructorAndFieldAstBuilder()
    
  public def BuildRouteClass(method as string, routeString as StringLiteralExpression, module as Module, body as Block) as ClassDefinition:
    rand = _randomNumber.Next()
      
    classDef = GetClassDefTemplate(method, routeString, body)
    
    routeBody = classDef.Members.Where({ x as TypeMember | x.Name == "RouteBody" }).Single() as Method
    classDef.Members.Remove(routeBody)
    newRouteBody = DoTransformationsOnRouteBody(routeBody)
    classDef.Members.Add(newRouteBody)
    
    rawDependencies = GetDependenciesForClass(body, module)
    
    classDef = PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef, rawDependencies)
    classDef.Name = classDef.Name + "_" + method + "_" + rand
    
    return classDef
  
  public def DoTransformationsOnRouteBody(routeBody as Method) as Method:
    paramsCollection = ExpressionStatement([| params = RouteParameters(ControllerContext.RouteData.Values) |])
    oldBody = routeBody.Body
    
    newBody = Block()
    newBody.Statements.Insert(0, paramsCollection)
    for i in oldBody.Statements:
      newBody.Statements.Add(i)
    
    routeBody.Body = newBody
    return routeBody
  
  public def GetDependenciesForClass(body as Block, module as Module) as ParameterDeclaration*:
    return _dependencyBuilder.GetDependenciesForClass(body, module)  
  
  public def PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef as ClassDefinition, rawDeps as ParameterDeclaration*) as ClassDefinition:
    return _constructorAndFieldAstBuilder.PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef, rawDeps)
  
  public def GetClassDefTemplate(method as string, routeString as StringLiteralExpression, body as Block) as ClassDefinition:
    classDef =  [|
      public class Mercury_route(MercuryControllerBase, IMercuryRouteAction):
        public def constructor():
          pass
        
        public override def RouteBody() as object:
          $(body)
        
        public HttpMethod as string:
          get:
            return $method
        
        public RouteString as string:
          get:
            return ("" if $routeString == "/" else $routeString)
        
        public HttpContext as HttpContextBase:
          get:
            return ControllerContext.HttpContext
        
        _viewEngines as ViewEngineCollection
        public ViewEngines as ViewEngineCollection:
          get:
            return _viewEngines
          set:
            _viewEngines = value
    |]
    
    return classDef