namespace Mercury.Core

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class DependencyMacro(AbstractAstMacro):
"""Description of DependencyMacro"""
  def constructor():
    pass

  public def Expand(macro as MacroStatement) as Statement:
    raise "'dependency' must either have one argument and no body or no arguments and a body" + macro.Body.Statements.Count if macro.Arguments.Count > 0 and macro.Body.Statements.Count != 0
    arg = macro.Arguments[0]
    raise "dependency argument must be passed in the following form: dependency depName as IDepService" if not arg isa TryCastExpression
    raise "args count: "+ macro.Arguments.Count + ' type: ' + arg.GetType().ToString()
    
    