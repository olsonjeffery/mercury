namespace Mercury.Specs.Behaviors

import System
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Machine.Specifications
import Machine.Specifications.NUnitShouldExtensionMethods from Machine.Specifications.NUnit
import Mercury.Core
import System.Linq.Enumerable from System.Core
import Mercury.Specs
import Rhino.Mocks
import Microsoft.Practices.ServiceLocation

public class BehaviorSpecs(Mercury.Specs.CommonSpecBase):
  context as Establish = def():
    behaviorMacro = BehaviorMacro()
    behaviorBuilder = BehaviorAstBuilder()
    targetMacro = TargetMacro()
    behaviorProcessor = BehaviorProcessor()
    startup = MercuryStartupService(container, viewEngines)
  
  protected static behaviorProcessor as BehaviorProcessor
  protected static behaviorMacro as BehaviorMacro
  protected static behaviorBuilder as BehaviorAstBuilder
  protected static exception as Exception
  protected static targetMacro as TargetMacro
  protected static macro as MacroStatement
  protected static classDef as ClassDefinition  
  protected static behaviorType as Type
  protected static behaviorCode as string
  protected static behaviorA as IBehavior
  protected static behaviorB as IBehavior
  protected static behaviorC as IBehavior
  protected static behaviors as List of IBehavior
  protected static sortedBehaviors as IBehavior*
  protected static rule as PrecedenceRule
  protected static behaviorLocation as int
  protected static startup as MercuryStartupService
  
  protected static def BehaviorMacroWithAStringForItsName():
    macro = MacroStatement()
    macro.Arguments.Add([| "fosdfsdfsd" |])
    return macro
  
  protected static def BehaviorMacroWithNoTarget():
    macro = MacroStatement()
    macro.Arguments.Add([| Foo |])
    beforeAction = [|
      block:
        foo = "bar"
    |]
    beforeAction.Annotate("isBeforeAction", true)
    macro.Body.Statements.Add(beforeAction)
    return macro
  
  protected static def TargetMacroWithAReferenceExpressionArgument():
    retVal = MacroStatement()
    retVal.Arguments.Add([| FooBar |]);
    retVal.Name = "target"
    return retVal
  
  protected static def BehaviorMacroWithASingleDependency():
    macro = BehaviorMacroWithNoBeforeOrAfterActionBlock()
    beforeAction = [|
      block:
        foo = "bar"
    |]
    beforeAction.Annotate("isBeforeAction", true)
    
    macro.Body.Statements.Add(beforeAction)
    return macro
  
  protected static def BehaviorMacroWithNoBeforeOrAfterActionBlock():
    retVal = MacroStatement
    macro.Arguments.Add([| BehaviorName |])
    
    target = MacroStatement()
    target.Arguments.Add([| "foo" |])
    targetResult = TargetMacro().Expand(target)
    
    dep = GenerateUnparsedDependencyOn(typeof(string), "foo")
    
    macro.Body = [|
      $targetResult
      $dep
    |]
    
    return macro
  
  protected static def BehaviorMacroWithTwoBeforeActionSegments():
    macro = BehaviorMacroWithNoBeforeOrAfterActionBlock()
    beforeAction1 = [|
      before_action:
        foo = "bar"
    |]
    beforeAction2 = [|
      before_action:
        foo = "bar"
    |]
    beforeMacro = Before_actionMacro()
    macro.Body.Statements.Add(beforeMacro.Expand(beforeAction1))
    macro.Body.Statements.Add(beforeMacro.Expand(beforeAction2))
    
    return macro
    
  protected static def BehaviorMacroWithTwoAfterActionSegments():
    macro = BehaviorMacroWithNoBeforeOrAfterActionBlock()
    afterAction1 = [|
      after_action:
        foo = "bar"
    |]
    afterAction2 = [|
      after_action:
        foo = "bar"
    |]
    afterMacro = After_actionMacro()
    macro.Body.Statements.Add(afterMacro.Expand(afterAction1))
    macro.Body.Statements.Add(afterMacro.Expand(afterAction2))
    
    return macro
  
public class AnotherBehavior(IBehavior):
  public def constructor():
    pass
  
  BeforeAction as BeforeAction:
    get:
      raise ""
  AfterAction as AfterAction:
    get:
      raise ""
  Targets as string*:
    get:
      raise ""
  PrecedenceRules as PrecedenceRule*:
    get:
      raise ""
  public def HasItsPrecedenceDependenciesMetBy(behaviors as IBehavior*) as bool:
    raise ""
    
  public def LocationToBeAddedToIn(behaviors as IBehavior*) as int:
    raise ""