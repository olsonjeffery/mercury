namespace Mercury.Core

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

class Run_lastMacro(AbstractAstMacro):
  
  _precedence as PrecedenceMacros
  def constructor():
    _precedence = PrecedenceMacros()
  
  public override def Expand(macro as MacroStatement) as Statement:
    return _precedence.MustRunLastExpand(macro)