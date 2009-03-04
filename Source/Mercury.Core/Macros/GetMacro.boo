namespace Mercury.Core

import System
import System.Text.RegularExpressions
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class GetMacro(AbstractAstMacro):
"""Description of GetMacro"""
  def constructor():
    pass
  
  public override def Expand(macro as MacroStatement) as Statement:
    raise "only one argument (string or regex) is allowed to get" if macro.Arguments.Count != 1
    raise "only string or regex is allowed as the argument to get, you provided: " + macro.Arguments[0].GetType() if not macro.Arguments[0].GetType() in (typeof(StringLiteralExpression), typeof(RELiteralExpression))
    
    parent as Node = macro
    while not parent isa Module:
      parent = parent.ParentNode
    
    rand = Random().Next()
      
    classDef = [|
      public class Mercury_route(IMercuryRoute):
        public def constructor():
          pass
          
        public def Execute():
          $(macro.Body)
    |]
    theType = [| typeof(System.String) |]
    
    classDef.GetConstructor(0).Parameters.Add(ParameterDeclaration("foo", theType.Type))
    classDef.Name = classDef.Name  + rand
    
    (parent as Module).Members.Add(classDef)