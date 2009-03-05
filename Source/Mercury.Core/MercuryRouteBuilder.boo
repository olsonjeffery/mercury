namespace Mercury.Core

import System
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class MercuryRouteBuilder:
"""Description of MercuryRouteBuilder"""
  def constructor():
    pass

  public def BuildRouteClass(method as string, routeString as string, module as Module, body as Block) as ClassDefinition:
    rand = Random().Next()
      
    classDef = [|
      public class Mercury_route(IMercuryRouteAction):
        public def constructor():
          pass
          
        public def Execute():
          $(body)
        
        public HttpMethod as string:
          get:
            return $(method)
        public RouteString as string:
          get:
            return $(routeString)
    |]
    
    rawDependencies = GetDependenciesForClass(body, module)
    
    
    classDef = PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef, rawDependencies)
    classDef.Name = classDef.Name + "_" + method + "_" + rand
    
    return classDef
  
  public def GetDependenciesForClass(body as Block, module as Module) as Dictionary[of string, ParameterDeclaration]:
    inActionDependencies = PullDependenciesFromMacroBody(body)
    moduleLevelDependencies = PullDependenciesFromModule(module)
    
    return MergeDependencyDictionaries(inActionDependencies, moduleLevelDependencies)
    
  
  public def PullDependenciesFromMacroBody(body as Block) as Dictionary [of string, ParameterDeclaration]:
    dict = Dictionary[of string, ParameterDeclaration]()
    
    deps = List of DeclarationStatement()
    for i in body.Statements:
      if i["dependency"]  == true:
        for j in (i as Block).Statements:
          deps.Add(j)
    
    raise "da count" + deps.Count
    
    return dict
  
  public def PullDependenciesFromModule(module as Module) as Dictionary [of string,ParameterDeclaration]:
    dict = Dictionary[of string, ParameterDeclaration]()
    return dict
    
  public def MergeDependencyDictionaries(inAction as Dictionary [of string, ParameterDeclaration], moduleLevel as Dictionary [of string, ParameterDeclaration]) as Dictionary [of string, ParameterDeclaration]:
    return Dictionary[of string, ParameterDeclaration]()
  
  public def PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef as ClassDefinition, deps as Dictionary[of string, ParameterDeclaration]) as ClassDefinition:
    theType = [| typeof(System.String) |]
    classDef.GetConstructor(0).Parameters.Add(ParameterDeclaration("foo", theType.Type))
    
    return classDef