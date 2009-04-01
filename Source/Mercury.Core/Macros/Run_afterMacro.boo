namespace Mercury.Core

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class Run_afterMacro(AbstractAstMacro):
  
  _precedence as PrecedenceMacros
  def constructor():
    _precedence = PrecedenceMacros()
  
  public override def Expand(macro as MacroStatement) as Statement:
    return _precedence.RunsAfterExpand(macro)