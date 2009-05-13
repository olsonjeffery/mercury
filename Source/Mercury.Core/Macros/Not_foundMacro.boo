namespace Mercury.Core

import System
import System.Text.RegularExpressions
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class Not_foundMacro(AbstractAstMacro):
  _builder as MercuryRouteAstBuilder

  def constructor():
    _builder = MercuryRouteAstBuilder()
  
  public override def Expand(macro as MacroStatement) as Statement:
    raise "no arguments are allowed to 'not_found'" if macro.Arguments.Count != 0
    
    routeString = StringLiteralExpression("{*url}")
    
    method = 'ANY'
    
    parent as Node = macro
    while not parent isa Module:
      parent = parent.ParentNode
    
    classDef = _builder.BuildRouteClass(method, routeString, parent as Module, macro.Body)
    
    (parent as Module).Members.Add(classDef)