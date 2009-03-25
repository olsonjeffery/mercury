namespace Mercury.Core

import System
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class BehaviorMacro(AbstractAstMacro):
  _behaviorAstBuilder as BehaviorAstBuilder
  
  def constructor():
    _behaviorAstBuilder = BehaviorAstBuilder()
  
  public override def Expand(macro as MacroStatement) as Statement:
    raise ArgumentException("only one argument to a 'behavior' is allowed") if macro.Arguments.Count != 1
    raise ArgumentException("A 'safe reference identifier' name (eg something you'd use to name a class, method, local var, etc) is the only valid name for a behavior") if not macro.Arguments[0] isa ReferenceExpression
    behaviorName = macro.Arguments[0].ToCodeString()
    
    parent as Node = macro
    while not parent isa Module:
      parent = parent.ParentNode
      
    classDef = _behaviorAstBuilder.BuildBehaviorClass(parent as Module, behaviorName, macro.Body)
    
    
    
    (parent as Module).Members.Add(classDef)