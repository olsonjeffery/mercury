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
  
  def constructor():
    _dependencyBuilder = DependencyAstBuilder()

  public def BuildRouteClass(method as string, routeString as StringLiteralExpression, module as Module, body as Block) as ClassDefinition:
    rand = _randomNumber.Next()
      
    classDef = GetClassDefTemplate(method, routeString, body)
    
    rawDependencies = GetDependenciesForClass(body, module)
    
    classDef = PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef, rawDependencies)
    classDef.Name = classDef.Name + "_" + method + "_" + rand
    
    return classDef
  
  public def GetDependenciesForClass(body as Block, module as Module) as ParameterDeclaration*:
    return _dependencyBuilder.GetDependenciesForClass(body, module)
  
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
  
  public def PopulateConstructorWithParametersFromDependencies(ctor as Constructor, params as ParameterDeclaration*):
    for i in params:
      ctor.Parameters.Add(i)
    return ctor
  
  public def PopulateClassDefinitionWithFieldsFromDependencies(classDef as ClassDefinition, fields as ParameterDeclaration*):
    for i in fields:
      field = Field(i.Type, [| null |])
      field.Name = i.Name
      classDef.Members.Add(field)
    
    return classDef
  
  public def PopulateConstructorWithFieldAssignmentsFromMethodParameters(ctor as Constructor):
    ctor.Body = Block()
    for i in ctor.Parameters:
      refExp = ReferenceExpression(i.Name)
      assignment = [| self.$(i.Name) = $(refExp) |]
      ctor.Body.Add(assignment)
    
    return ctor
  
  public def PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef as ClassDefinition, deps as ParameterDeclaration*) as ClassDefinition:
    return classDef if deps.Count() == 0
    ctor = Constructor()
    
    classDef = PopulateClassDefinitionWithFieldsFromDependencies(classDef, deps)
    ctor = PopulateConstructorWithParametersFromDependencies(ctor, deps)
    ctor = PopulateConstructorWithFieldAssignmentsFromMethodParameters(ctor)
    
    classDef.Members.Add(ctor)
    return classDef