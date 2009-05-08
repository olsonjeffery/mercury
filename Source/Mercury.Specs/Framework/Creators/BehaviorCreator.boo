namespace Mercury.Specs

import System
import Mercury.Core

public class BehaviorCreator(FixtureService[of IBehavior]):
  
  public def constructor():
    Creation = StubBehavior()
  
  public def WithBeforeAction(before as BeforeAction):
    (Creation as StubBehavior).SetBeforeAction(before)
    return self
  
  public def WithAfterAction(after as AfterAction):
    (Creation as StubBehavior).SetAfterAction(after)
    return self

public class StubBehavior(IBehavior):
  
  _beforeAction as BeforeAction
  public BeforeAction:
    get:
      return _beforeAction
  
  _afterAction as AfterAction
  public AfterAction:
    get:
      return _afterAction
  
  public def SetBeforeAction(before as BeforeAction):
    _beforeAction = before
  
  public def SetAfterAction(after as AfterAction):
    _afterAction = after