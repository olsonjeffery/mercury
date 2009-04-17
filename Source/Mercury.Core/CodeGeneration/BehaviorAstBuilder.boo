namespace Mercury.Core

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import System.Collections.Generic
import System.Linq.Enumerable from System.Core

public class BehaviorAstBuilder:
  _dependencyBuilder as DependencyAstBuilder
  _constructorAndFieldAstBuilder as ConstructorAndFieldAstBuilder
  _propertyAstBuilder as PropertyAstBuilder
  _isAConstructor = { x as TypeMember | x isa Constructor }  
  
  public def constructor():
    _dependencyBuilder = DependencyAstBuilder()
    _constructorAndFieldAstBuilder = ConstructorAndFieldAstBuilder()
    _propertyAstBuilder = PropertyAstBuilder()
  
  public def BuildBehaviorClass(module as Module, name as string, body as Block) as ClassDefinition:
    
    targets = List of StringLiteralExpression()
    for i in body.Statements:   
      targets.Add(i["targetVal"] as StringLiteralExpression) if i["isTarget"]
    raise NoTargetException() if targets.Count == 0
    
    before as Block = null
    hasBeforeAlready = false
    after as Block = null
    hasAfterAlready = false
    rules = List of PrecedenceRule()
    for i as Statement in body.Statements:
      if i["isBeforeAction"]:
        before = (i if i isa Block else (i as MacroStatement).Body)
        raise BehaviorHasMoreThanOneBeforeActionSegmentException() if hasBeforeAlready
        hasBeforeAlready = true;
      elif i["isAfterAction"]:
        after = (i if i isa Block else (i as MacroStatement).Body)
        raise BehaviorHasMoreThanOneAfterActionSegmentException() if hasAfterAlready
        hasAfterAlready = true;
      elif i["isPrecedence"]:
        rules.Add(CreatePrecedenceRule(i))
    raise BehaviorHasNoBeforeOrAfterAfterSegmentException() if not hasAfterAlready and not hasBeforeAlready
    
    classDef = GetClassDefintionTemplate(name)
    
    deps = _dependencyBuilder.GetDependenciesForClass(body, module)
    classDef = _constructorAndFieldAstBuilder.PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef, deps)
    
    classDef = AddBeforeAction(classDef, before)
    classDef = AddAfterAction(classDef, after)
    classDef = AddTargets(classDef, targets)
    classDef = AddPrecedenceRules(classDef, rules)
    
    return classDef
  
  public def CreatePrecedenceRule(i as Statement) as PrecedenceRule:
    return PrecedenceRule(string.Empty, i["precedenceType"]) if i["precedenceType"] in (Precedence.RunFirst, Precedence.RunLast)
    return PrecedenceRule(i["precedenceValue"], i["precedenceType"]) if i["precedenceType"] in (Precedence.RunBefore, Precedence.RunAfter)
    raise "malformed precedence rule from macro!"
  
  public def ProcessPrecedenceRule(precedenceRule as PrecedenceRule) as Statement:
    precName = precedenceRule.TargetName
    precType = precedenceRule.Precedence

    return ExpressionStatement([| tempList.Add(PrecedenceRule($(precName), Precedence.$(precType.ToString()) )) |]) if (precType in (Precedence.RunBefore, Precedence.RunAfter))
    return ExpressionStatement([| tempList.Add(PrecedenceRule(string.Empty, Precedence.$(precType.ToString()) )) |]) if (precType in (Precedence.RunFirst, Precedence.RunLast))
    raise "malformed precedence rules!"
  
  public def GetClassDefintionTemplate(name as string):
    return [|
      public class $name(IBehavior):
        
        public def constructor():
          pass
        
        _targets as string*
        _beforeAction as BeforeAction
        _afterAction as AfterAction
        _precedenceRules as PrecedenceRule*
        
        public override def ToString() as string:
          return self.GetType().FullName + ".. targetting: '"+join(i for i in _targets, ", ")+"'"
        
        public virtual def HasItsPrecedenceDependenciesMetBy(behaviors as IBehavior*) as bool:
          unsatisfiedRules = { x | x == false }
          results = System.Collections.Generic.List of bool()
          
          for rule in _precedenceRules:
            results.Add(rule.IsSatisfiedBy(behaviors))
          //dependenciesAreMet = List of bool(System.Linq.Enumerable.Where(results, unsatisfiedRules)).Count == 0
          dependenciesAreMet = List of bool (i for i in results if not i).Count == 0
          return dependenciesAreMet
        
        public virtual def LocationToBeAddedToIn(behaviors as IBehavior*) as int:
          return -99 if not HasItsPrecedenceDependenciesMetBy(behaviors)
          locations = List of int(i.LocationToBeAddedToIn(behaviors) for i in _precedenceRules)
          addToEndLocations = List of int(i for i in locations if i == -1)
          dropAddToEndLocations = List of int(i for i in locations if not i == -1).Sort()
          return dropAddToEndLocations[0] if dropAddToEndLocations.Count > 0
          return -1 if locations.Count == addToEndLocations.Count
          raise "Unable to figure out where to put this behavior!"
    |]
  
  public def AddBeforeAction(classDef as ClassDefinition, before as Block) as ClassDefinition:
    beforeProperty = _propertyAstBuilder.SimpleGetterProperty("BeforeAction", "_beforeAction", [| typeof(BeforeAction) |].Type)
    classDef.Members.Add(beforeProperty)
    for ctor as Constructor in classDef.Members.Where(_isAConstructor):
      if before is null:
        ctor.Body.Statements.Add(ExpressionStatement([| self._beforeAction = null |]))
      else:
        addBeforeExp = BlockExpression(before)
        paramTypeDef = [| typeof(ControllerContext) |].Type
        addBeforeExp.Parameters.Add( ParameterDeclaration("request", paramTypeDef))
        ctor.Body.Statements.Add(ExpressionStatement([| self._beforeAction = $addBeforeExp |]))
    return classDef
  
  public def AddAfterAction(classDef as ClassDefinition, after as Block) as ClassDefinition:
    afterProperty = _propertyAstBuilder.SimpleGetterProperty("AfterAction", "_afterAction", [| typeof(AfterAction) |].Type)
    classDef.Members.Add(afterProperty)
    for ctor as Constructor in classDef.Members.Where(_isAConstructor):
      if after is null:
        ctor.Body.Statements.Add(ExpressionStatement([| self._afterAction = null |]))
      else:
        addAfterExp = BlockExpression(after)
        paramTypeDef = [| typeof(ControllerContext) |].Type
        addAfterExp.Parameters.Add( ParameterDeclaration("request", paramTypeDef))
        ctor.Body.Statements.Add(ExpressionStatement([| self._afterAction = $addAfterExp |]))
    return classDef
  
  public def AddTargets(classDef as ClassDefinition, targets as StringLiteralExpression*) as ClassDefinition:
    targetsProperty = _propertyAstBuilder.SimpleGetterProperty("Targets", "_targets", [| typeof(string*) |].Type)
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

    for ctor as Constructor in classDef.Members.Where(_isAConstructor):
      ctor.Body.Statements.Add(ExpressionStatement([| self.AddTargets() |]))
    
    return classDef
  
  public def AddPrecedenceRules(classDef as ClassDefinition, rules as PrecedenceRule*) as ClassDefinition:
    runsFirstOrLast = { x as PrecedenceRule | x.Precedence in (Precedence.RunFirst, Precedence.RunLast) }
    raise ExpansionTimePrecedenceRuleException() if rules.Where(runsFirstOrLast).Count() > 0 and rules.Count() > 1
    
    for rule in rules:
      areInConflict = { x as PrecedenceRule | x.ConflictsWith(rule) and not x is rule }
      raise ExpansionTimePrecedenceRuleException() if rules.Where(areInConflict).Count() > 0
    
    precedenceProperty = _propertyAstBuilder.SimpleGetterProperty("PrecedenceRules", "_precedenceRules", [| typeof(PrecedenceRule*) |].Type)
    classDef.Members.Add(precedenceProperty)
    
    addPrecedenceMethod = [|
      private def AddPrecedenceRules():
        pass
    |]
    addPrecedenceMethod.Body = Block()
    addPrecedenceMethod.Body.Statements.Add(ExpressionStatement([| tempList = System.Collections.Generic.List of PrecedenceRule() |]))
    
    for rule in rules:
      statement = ProcessPrecedenceRule(rule)
      addPrecedenceMethod.Body.Statements.Add(statement)
    
    addPrecedenceMethod.Body.Statements.Add(ExpressionStatement([| _precedenceRules = tempList |]))
    
    classDef.Members.Add(addPrecedenceMethod)
    
    for ctor as Constructor in classDef.Members.Where(_isAConstructor):
      ctor.Body.Statements.Add(ExpressionStatement([| self.AddPrecedenceRules() |]))
    
    return classDef