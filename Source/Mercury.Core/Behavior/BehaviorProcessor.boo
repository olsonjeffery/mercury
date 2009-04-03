namespace Mercury.Core

import System
import System.Collections.Generic

public class BehaviorProcessor:
  
  def constructor():
    pass
  
  public def OrderBehaviors(unordered as IBehavior*) as IBehavior*:
    return unordered