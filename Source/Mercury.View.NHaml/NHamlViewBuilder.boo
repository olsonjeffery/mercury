namespace Mercury.Core

import System
import NHaml.Web.Mvc
import Mercury.Core
import System.Web.Mvc
import System.Linq.Enumerable from System.Core

public class NHamlViewBuilder:
  public def constructor():
    pass


  public def GetView(viewData as ViewDataDictionary, tempData as TempDataDictionary, viewPath as string, viewEngines as ViewEngineCollection, controllerContext as ControllerContext) as RenderViewResult:
    masterName as string = (viewData["nhamlMasterName"] if viewData.ContainsKey("nhamlMasterName") else null)
    
    nhamlViewEngineTemp = (i for i in viewEngines if i isa MercuryNHamlViewEngine).ToList()
    if nhamlViewEngineTemp.Count == 0:
      raise "No nhaml engine registered!"
    if nhamlViewEngineTemp.Count > 1:
      raise "Multiple nhaml view engines registered!"
    nhamlViewEngine = nhamlViewEngineTemp[0] as MercuryNHamlViewEngine
    
    view = nhamlViewEngine.CreateView(controllerContext, viewPath, masterName)
    raise "View is null for path: '"+viewPath+"' .. chances are this is because of a malformed path" if view is null
    viewContext = ViewContext(controllerContext, view, viewData, tempData)
    return RenderViewResult(viewContext, view, controllerContext.HttpContext.Response.Output)