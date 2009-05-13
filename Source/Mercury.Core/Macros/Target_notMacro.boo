namespace Mercury.Core

import System
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class Target_notMacro(AbstractAstMacro):
  
  def constructor():
    pass
    
  public override def Expand(macro as MacroStatement) as Statement:
    raise ArgumentException("Only one argument must be specified to 'target_not'. It must be a regular expression literal of a string.") if macro.Arguments.Count != 1
    raise ArgumentException("The argument to 'target_not' must be a regular expression or a string") if not macro.Arguments[0] isa RELiteralExpression and not macro.Arguments[0] isa StringLiteralExpression
    raise ArgumentException("The 'target_not' macro cannot have a body") if macro.Body.Statements.Count > 0
    retStatement = macro.Body
    //retStatement = Statement()
    retStatement.Annotate("isTargetNot", true)
    retStatement.Annotate("targetNotVal", (macro.Arguments[0] if macro.Arguments[0] isa StringLiteralExpression else StringLiteralExpression((macro.Arguments[0] as RELiteralExpression).ToCodeString())))
    return retStatement