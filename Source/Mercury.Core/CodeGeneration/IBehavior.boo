namespace Mercury.Core

import System
import System.Web
import System.Web.Mvc

public callable BeforeAction(request as ControllerContext)
public callable AfterAction(request as ControllerContext)

public interface IBehavior:
  BeforeAction as BeforeAction:
    get
  AfterAction as AfterAction:
    get
  Targets as string*:
    get
  PrecedenceRules as string*:
    get