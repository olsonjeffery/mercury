namespace Mercury.Core

import System
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class BehaviorMacro(AbstractAstMacro):

  def constructor():
    pass
  
  public override def Expand(macro as MacroStatement) as Statement:
    classDef = [|
      public class Behavior:
        
        public def constructor():
          pass
    |]
    parent as Node = macro
    while not parent isa Module:
      parent = parent.ParentNode
    
    (parent as Module).Members.Add(classDef)