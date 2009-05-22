namespace Mercury.Core

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Boo.Lang.PatternMatching
import System.Web.Mvc

macro spark(path as string):
  result = AspNetMvcPathSplitKludge().SplitPath(path, true, ".spark")
  controller = result[0]
  view = result[1]
  
  body = Block()
  body.Statements.Add([| return SparkViewBuilder().GetView(ViewData, TempData, $(StringLiteralExpression(controller)), $(StringLiteralExpression(view)), ViewEngines, self.ControllerContext) |])
  return body
  
  /*
  foo = [|
    masterName as string = (ViewData["masterName"] if ViewData.ContainsKey("masterName") else null)
    ControllerContext.RequestContext.RouteData.Values.Add("controller", $(StringLiteralExpression(controller)))
    sparkViewGenerator = i for i in ViewEngines if i.GetType().Name == "SparkViewFactory"
    sparkViewEngine = List of IViewEngine(sparkViewGenerator)
    raise "No spark engine registered!" if sparkViewEngine.Count == 0
    raise "Multiple spark view engines registered!" if sparkViewEngine.Count > 1
    //viewEngineResult = ViewEngines[1].FindView(self.ControllerContext, "Index", masterName, false)
    //viewEngineResult = ViewEngines.FindView(self.ControllerContext, "Index", masterName)
    viewEngineResult = sparkViewEngine[0].FindView(self.ControllerContext, $(StringLiteralExpression(view)), masterName, false)
    viewContext = ViewContext(ControllerContext, viewEngineResult.View, ViewData, TempData)
    return RenderViewResult(viewContext, viewEngineResult, ControllerContext.HttpContext.Response.Output)
  |]*/