namespace Mercury.Core

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import System.Collections.Generic
import System.Linq.Enumerable from System.Core

public class BehaviorAstBuilder:
  _dependencyBuilder as DependencyAstBuilder
  _constructorAndFieldAstBuilder as ConstructorAndFieldAstBuilder
  
  public def constructor():
    _dependencyBuilder = DependencyAstBuilder()
    _constructorAndFieldAstBuilder = ConstructorAndFieldAstBuilder()

  
  public def BuildBehaviorClass(module as Module, name as string, body as Block) as ClassDefinition:
    
    target = List of string()
    for i in body.Statements:   
      target.Add(i["targetVal"] as string) if i["isTarget"]
    raise NoTargetException() if target.Count == 0
    
    classDef = [|
      public class Behavior:
        
        public def constructor():
          pass
    |]
    
    deps = _dependencyBuilder.GetDependenciesForClass(body, module)
    classDef = _constructorAndFieldAstBuilder.PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef, deps)
    
    return classDef