namespace Mercury.Core

import System
import System.Web.Mvc

public class SparkViewBuilder:
  public def constructor():
    pass
  
  public def GetView(viewData as ViewDataDictionary, tempData as TempDataDictionary, controller as string, view as string, viewEngines as ViewEngineCollection, controllerContext as ControllerContext) as RenderViewResult:
    masterName as string = (viewData["masterName"] if viewData.ContainsKey("masterName") else null)
    controllerContext.RequestContext.RouteData.Values.Add("controller", controller)
    sparkViewGenerator = i for i in viewEngines if i.GetType().Name == "SparkViewFactory"
    sparkViewEngine = List[of IViewEngine](sparkViewGenerator)
    if sparkViewEngine.Count == 0:
      raise "No spark engine registered!"
    if sparkViewEngine.Count > 1:
      raise "Multiple spark view engines registered!"
    
    viewEngineResult = sparkViewEngine[0].FindView(controllerContext, view, masterName, false)
    raise "ViewEngineResult is null for path: '"+controller+"/"+view+"' .. chances are this is because of a malformed path" if viewEngineResult is null
    viewContext = ViewContext(controllerContext, viewEngineResult.View, viewData, tempData)
    return RenderViewResult(viewContext, viewEngineResult, controllerContext.HttpContext.Response.Output)

