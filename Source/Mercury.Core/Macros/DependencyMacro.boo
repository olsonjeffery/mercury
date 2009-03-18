namespace Mercury.Core

import System
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class DependencyMacro(AbstractAstMacro):
"""Description of DependencyMacro"""
  def constructor():
    pass

  public def Expand(macro as MacroStatement) as Statement:
    raise "'dependency' must either have one argument and no body or no arguments and a body" + macro.Body.Statements.Count if macro.Arguments.Count == 1 and macro.Body.Statements.Count != 0
    singleDependency = macro.Arguments.Count == 1
    
    deps = List of DeclarationStatement()
    
    if singleDependency:
      rawDep = macro.Arguments[0] as TryCastExpression
      dep = DeclarationStatement(Declaration(rawDep.Target.ToString(), rawDep.Type), [| null |])
      deps.Add(dep)
    else:
      for i in macro.Body.Statements:
        raise "contents of the body of a dependency block must be only in the form of 'fooService as IFooService', provided: "+i.GetType().ToString() if not i isa DeclarationStatement
        deps.Add(i)
    
    block = Block()
    for i in deps:
      block.Statements.Add(i)
    
    block.Annotate("dependency", true)
    
    //raise block.Statements.Count.ToString()
    return block