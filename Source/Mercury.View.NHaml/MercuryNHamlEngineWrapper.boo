namespace Mercury.Core

import System
import NHaml.Web.Mvc
import System.Web.Mvc

public class MercuryNHamlViewEngine(NHamlMvcViewEngine):
"""Description of MercuryNHamlEngineWrapper"""
  public def constructor():
    pass
  
  public def CreateViewWrapper(ctrlContext as ControllerContext, viewPath as string, masterPath as string):
    return CreateView(ctrlContext, viewPath, masterPath)

