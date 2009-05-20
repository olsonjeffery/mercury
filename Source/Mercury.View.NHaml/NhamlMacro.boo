namespace Mercury.Core

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Boo.Lang.PatternMatching

macro nhaml(path as string):
  yield [| return NHamlViewBuilder().GetView(ViewData, TempData, $path, ViewEngines, self.ControllerContext) |]