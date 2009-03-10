namespace Mercury.Core

import System
import System.Collections.Generic
import System.Linq.Enumerable from System.Core
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class MercuryRouteBuilder:
  private static _randomNumber as Random = Random()
  
  def constructor():
    pass

  public def BuildRouteClass(method as string, routeString as StringLiteralExpression, module as Module, body as Block) as ClassDefinition:
    rand = _randomNumber.Next()
      
    classDef = [|
      public class Mercury_route(IMercuryRouteAction):
        public def constructor():
          pass
        
        public def Execute():
          $(body)
        
        public HttpMethod as string:
          get:
            return $method
        public RouteString as string:
          get:
            return $routeString
    |]
    
    rawDependencies = GetDependenciesForClass(body, module)
    
    classDef = PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef, rawDependencies)
    classDef.Name = classDef.Name + "_" + method + "_" + rand
    
    return classDef
  
  public def GetDependenciesForClass(body as Block, module as Module) as ParameterDeclaration*:
    inActionDependencies = PullDependenciesFromMacroBody(body)
    moduleLevelDependencies = PullDependenciesFromModule(module)
    
    return MergeDependencyLists(inActionDependencies, moduleLevelDependencies)
    
  
  public def PullDependenciesFromMacroBody(body as Block) as ParameterDeclaration*:
    list = List of ParameterDeclaration()
    for i in body.Statements:
      if i["dependency"]  == true:
        for j as DeclarationStatement in (i as Block).Statements:
          list.Add(ParameterDeclaration(j.Declaration.Name, j.Declaration.Type))
    raise DuplicateDependencyException() if not VerifyNoOverlappingDependencyNames(list)
    return list
  
  public def PullDependenciesFromModule(module as Module) as ParameterDeclaration*:
    list = List of ParameterDeclaration()
    return list
    
  public def MergeDependencyLists(inAction as ParameterDeclaration*, moduleLevel as ParameterDeclaration*) as ParameterDeclaration*:
    list = List of ParameterDeclaration()
    for i in inAction:
      list.Add(i)
    for i in moduleLevel:
      list.Add(i)
    raise DuplicateDependencyException() if not VerifyNoOverlappingDependencyNames(list)
    return list
  
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
    return ctor
  
  public def PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef as ClassDefinition, deps as ParameterDeclaration*) as ClassDefinition:
    return classDef if deps.Count() == 0
    ctor = Constructor()
    
    classDef = PopulateClassDefinitionWithFieldsFromDependencies(classDef, deps)
    ctor = PopulateConstructorWithParametersFromDependencies(ctor, deps)
    ctor = PopulateConstructorWithFieldAssignmentsFromMethodParameters(ctor)
    
    classDef.Members.Add(ctor)
    return classDef
  
  public def VerifyNoOverlappingDependencyNames(deps as ParameterDeclaration*) as bool:
    tempDict = Dictionary[of string, ParameterDeclaration]()
    for i in deps:
      return false if tempDict.ContainsKey(i.Name)
      tempDict[i.Name] = i
    return true