namespace Mercury.Core

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class HaltMacro(AbstractAstMacro):
  
  public def constructor():
    pass
  
  public override def Expand(macro as MacroStatement):
    raise "The first argument to halt must be an integer or decimal to return in the Response.StatusCode (and SubStatusCode, if a decimal if returned)" if not macro.Arguments[0] isa IntegerLiteralExpression and not macro.Arguments[0] isa DoubleLiteralExpression
    raise "The second argument to halt must be a string to be written to the Response.Output" if macro.Arguments.Count.Equals(2) and not macro.Arguments[1] isa StringLiteralExpression
    raise "Only one or two arguments is allowed to halt. syntax: 'halt <status code as int> [<output as string>]'" if not macro.Arguments.Count in (1, 2)
    
    rawStatusCode = macro.Arguments[0]
    withSubSTatus = rawStatusCode isa DoubleLiteralExpression
    statusCode as IntegerLiteralExpression
    subStatusCode as IntegerLiteralExpression
    if withSubSTatus:
      rawDouble = (rawStatusCode as DoubleLiteralExpression).Value.ToString("0.#").Split((",", "."), StringSplitOptions.None)
      statusCode = IntegerLiteralExpression(int.Parse(rawDouble[0]))
      subStatusCode = IntegerLiteralExpression(int.Parse(rawDouble[1]))
    else:
      statusCode = rawStatusCode
    
    output as StringLiteralExpression
    output = macro.Arguments[1] if macro.Arguments.Count.Equals(2)
    body = Block()
    body.Statements.Add(ExpressionStatement([| ControllerContext.HttpContext.Response.StatusCode = $statusCode |]))
    body.Statements.Add(ExpressionStatement([| ControllerContext.HttpContext.Response.SubStatusCode = $subStatusCode |])) if withSubSTatus
    
    if output is null:
      body.Statements.Add([| return null |])
    else:
      body.Statements.Add([| return $output |])
    
    return body