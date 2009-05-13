namespace Mercury.Core

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Boo.Lang.PatternMatching

macro redirect(url as string):
  yield [| return RedirectBuilder().GetRedirect(ControllerContext.HttpContext.Response, $url) |]