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
    
    rawDependencies = GetDependenciesForClass(body, module)
    
    classDef = PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef, rawDependencies)
    classDef.Name = classDef.Name + "_" + method + "_" + rand
    
    return classDef
  
  public def GetDependenciesForClass(body as Block, module as Module) as ParameterDeclaration*:
    return _dependencyBuilder.GetDependenciesForClass(body, module)  
  
  public def PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef as ClassDefinition, rawDeps as ParameterDeclaration*) as ClassDefinition:
    return _constructorAndFieldAstBuilder.PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef, rawDeps)
  
  public def GetClassDefTemplate(method as string, routeString as StringLiteralExpression, body as Block) as ClassDefinition:
    return  [|
      public class Mercury_route(MercuryControllerBase, IMercuryRouteAction):
        public def constructor():
          pass
        
        public override def ExecuteCore():
          $(body)
        
        public HttpMethod as string:
          get:
            return $method
        public RouteString as string:
          get:
            return $routeString
        
        public HttpContext as HttpContextBase:
          get:
            return ControllerContext.HttpContext
        
        [property(ViewEngines)]
        _viewEngines as ViewEngineCollection
    |]