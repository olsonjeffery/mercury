namespace Mercury.Core

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

class After_actionMacro(AbstractAstMacro):
"""Description of Before_actionMacro"""
  def constructor():
    pass
  
  public override def Expand(macro as MacroStatement) as Statement:
    body as Block = macro.Body
    body.Annotate("isAfterAction", true)
    return body