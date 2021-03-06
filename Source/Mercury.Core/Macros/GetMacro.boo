namespace Mercury.Core

import System
import System.Text.RegularExpressions
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class GetMacro(AbstractAstMacro):
  _builder as MercuryRouteAstBuilder

  def constructor():
    _builder = MercuryRouteAstBuilder()
  
  public override def Expand(macro as MacroStatement) as Statement:
    arg = macro.Arguments[0]
    raise "only one argument (string) is allowed to get" if macro.Arguments.Count != 1
    raise "only string is allowed as the argument to get, you provided: " + arg.GetType() if not arg isa StringLiteralExpression
    
    routeString = (arg as StringLiteralExpression)
    
    method = 'GET'
    
    parent as Node = macro
    while not parent isa Module:
      parent = parent.ParentNode
    
    classDef = _builder.BuildRouteClass(method, routeString, parent as Module, macro.Body)
    
    (parent as Module).Members.Add(classDef)