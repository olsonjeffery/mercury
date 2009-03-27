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
    
    targets = List of string()
    for i in body.Statements:   
      targets.Add(i["targetVal"] as string) if i["isTarget"]
    raise NoTargetException() if targets.Count == 0
    
    before as Block = null
    hasBeforeAlready = false
    after as Block = null
    hasAfterAlready = false
    for i in body.Statements:
      if i["isBeforeAction"]:
        before = (i if i isa Block else (i as MacroStatement).Body)
        raise BehaviorHasMoreThanOneBeforeActionSegmentException() if hasBeforeAlready
        hasBeforeAlready = true;
      if i["isAfterAction"]:
        after = (i if i isa Block else (i as MacroStatement).Body)
        raise BehaviorHasMoreThanOneAfterActionSegmentException() if hasAfterAlready
        hasAfterAlready = true;
    raise BehaviorHasNoBeforeOrAfterAfterSegmentException() if not hasAfterAlready and not hasBeforeAlready
    
    classDef = GetClassDefintionTemplate(name)
    
    deps = _dependencyBuilder.GetDependenciesForClass(body, module)
    classDef = _constructorAndFieldAstBuilder.PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef, deps)
    
    classDef = AddTargets(classDef, targets)
    classDef = AddPrecedenceRules(classDef, List of string())
    
    return classDef
  
  public def GetClassDefintionTemplate(name as string):
    return [|
      public class $name(IBehavior):
        
        public def constructor():
          pass
    |]
  
  public def AddTargets(classDef as ClassDefinition, targets as string*) as ClassDefinition:
    return classDef
  
  public def AddPrecedenceRules(classDef as ClassDefinition, rules as string*) as ClassDefinition:
    return classDef