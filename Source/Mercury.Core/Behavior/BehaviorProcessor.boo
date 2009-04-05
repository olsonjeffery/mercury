namespace Mercury.Core

import System
import System.Collections.Generic

public class BehaviorProcessor:
  
  def constructor():
    pass
  
  public def OrderBehaviors(unordered as IBehavior*) as IBehavior*:
    ordered = List of IBehavior()
    
    alreadyHaveRunFirst = false
    alreadyHaveRunLast = false
    for behavior in unordered:
      for precedenceRule in behavior.PrecedenceRules:
        if precedenceRule.Precedence is Precedence.RunFirst:
          raise MultipleRunFirstBehaviorsException() if alreadyHaveRunFirst
          alreadyHaveRunFirst = true
          ordered.Add(beavior)
          continue
    
    behaviorAddedInLastPass = true
    while behaviorAddedInLastPass:
      for behavior in unordered:
        if behavior in ordered:
          continue
        raise "we fuckin suck!"
    
    return ordered