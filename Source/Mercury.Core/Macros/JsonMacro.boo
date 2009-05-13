namespace Mercury.Core

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

macro json:
  raise "only one argument to the json macro is allowed" if json.Arguments.Count != 1
  body = Block()
  body.Statements.Add([| return JsonResultBuilder().GetJson(ControllerContext, $(json.Arguments[0])) |])
  return body