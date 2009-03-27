namespace Mercury.Core

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

class Before_actionMacro(AbstractAstMacro):
"""Description of Before_actionMacro"""
  def constructor():
    pass
  
  public override def Expand(macro as MacroStatement) as Statement:
    body as Block = macro.Body
    body.Annotate("isBeforeAction", true)
    return body