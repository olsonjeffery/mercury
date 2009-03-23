namespace Mercury.Core

import System
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class TargetMacro(AbstractAstMacro):
  
  def constructor():
    pass
    
  public override def Expand(macro as MacroStatement) as Statement:
    raise ArgumentException("Only one argument must be specified to 'target'. It must be a regular expression literal of a string.") if macro.Arguments.Count != 1
    raise ArgumentException("The argument to 'target' must be a regular expression or a string") if not macro.Arguments[0] isa RELiteralExpression and not macro.Arguments[0] isa StringLiteralExpression
    raise ArgumentException("The 'target' macro cannot have a body") if macro.Body.Statements.Count > 0
    retStatement = macro.Body
    //retStatement = Statement()
    retStatement.Annotate("isTarget", true)
    retStatement.Annotate("targetVal", macro.Arguments[0].ToString())
    return retStatement