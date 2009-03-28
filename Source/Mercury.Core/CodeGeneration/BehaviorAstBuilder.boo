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
    
    targets = List of StringLiteralExpression()
    for i in body.Statements:   
      targets.Add(i["targetVal"] as StringLiteralExpression) if i["isTarget"]
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
        
        _targets as string*
    |]
  
  public def AddTargets(classDef as ClassDefinition, targets as StringLiteralExpression*) as ClassDefinition:
    targetsProperty = Property("Targets")
    targetsProperty.Type = [| typeof(System.Collections.Generic.IEnumerable[of string]) |].Type
    targetsProperty.Getter = [|
      def get_Targets() as string*:
        return _targets
    |]
    classDef.Members.Add(targetsProperty)
    
    addTargetsMethod = [|
      private def AddTargets():
        pass
    |]
    addTargetsMethod.Body = Block() 
    addTargetsMethod.Body.Statements.Add(ExpressionStatement([| tempList = System.Collections.Generic.List of string() |]))
    
    for target in targets:
      addTargetsMethod.Body.Statements.Add(ExpressionStatement([| tempList.Add($target) |]))
    
    addTargetsMethod.Body.Statements.Add(ExpressionStatement([| _targets = tempList |]))
    
    classDef.Members.Add(addTargetsMethod)

    isAConstructor = { x as TypeMember | x isa Constructor }
    for ctor as Constructor in classDef.Members.Where(isAConstructor):
      ctor.Body.Statements.Add(ExpressionStatement([| self.AddTargets() |]))
    
    return classDef
  
  public def AddPrecedenceRules(classDef as ClassDefinition, rules as string*) as ClassDefinition:
    return classDef