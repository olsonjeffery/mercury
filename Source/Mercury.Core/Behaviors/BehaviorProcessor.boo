namespace Mercury.Core

import System
import System.Text
import System.Collections.Generic
import System.Linq.Enumerable from System.Core

public class BehaviorProcessor:
  
  def constructor():
    pass
  
  public def OrderBehaviors(unordered as IBehavior*) as IBehavior*:
    ordered = List of IBehavior()
    ordered = FindRunFirstBehaviorIfAny(unordered, ordered)
    ordered = FindRunBeforeAndAfterBehaviors(unordered, ordered)
    ordered = FindRunLastBehaviorIfAny(unordered, ordered)
    raise "No duplicate behaviors allowed" if OrderedListContainsDuplicates(ordered)
    RaiseOnUnsatisifedBehaviors(unordered, ordered) if unordered.Count() != ordered.Count
    
    return ordered
  
  public def OrderedListContainsDuplicates(ordered as List of IBehavior) as bool:
    list = List of string()
    for i in ordered:
      typeFullName = i.GetType().FullName
      return true if list.Contains(typeFullName)
      list.Add(typeFullName)
    
  
  public def FindRunBeforeAndAfterBehaviors(unordered as IBehavior*, ordered as List of IBehavior) as IBehavior*:
    behaviorAddedInLastPass = true
    while behaviorAddedInLastPass:
      newlyAdded = List of IBehavior()
      for behavior in unordered:
        addThisBehavior = false
        
        continue if behavior in ordered
        isRunLast = { x as PrecedenceRule | x.Precedence == Precedence.RunLast }
        continue if behavior.PrecedenceRules.Where(isRunLast).Count() > 0
        
        location = behavior.LocationToBeAddedToIn(ordered)
        addThisBehavior = location != -99
        
        ordered.Add(behavior) if addThisBehavior and location == -1 // -1 means "add to the end"
        ordered.Insert(location, behavior) if addThisBehavior and not location == -1
        newlyAdded.Add(behavior) if addThisBehavior
      behaviorAddedInLastPass = false if newlyAdded.Count == 0
    return ordered
  
  public def RaiseOnUnsatisifedBehaviors(unordered as IBehavior*, ordered as List of IBehavior):
    unsatisfiedDependencies = i for i in unordered if not i in (ordered)
    message = StringBuilder()
    message.AppendLine("Behavior with unsatisfied precedence rules:")
    for i as IBehavior in unsatisfiedDependencies:
      message.AppendLine("behavior: "+i.GetType().Name+" with rules:")
      for rule in i.PrecedenceRules:
        message.AppendLine("\tTargetting: '"+ rule.TargetName+"' with a precedence of "+rule.Precedence.ToString()) 
    raise UnsatisfiedBehaviorsException(message.ToString())
    
  public def FindRunFirstBehaviorIfAny(unordered as IBehavior*, ordered as List of IBehavior) as IBehavior*:
    alreadyHaveRunFirst = false
    for behavior in unordered:
      for precedenceRule in behavior.PrecedenceRules:
        if precedenceRule.Precedence == Precedence.RunFirst:
          raise MultipleRunFirstBehaviorsException() if alreadyHaveRunFirst
          alreadyHaveRunFirst = true
          ordered.Add(behavior)
    return ordered
  
  public def FindRunLastBehaviorIfAny(unordered as IBehavior*, ordered as List of IBehavior) as IBehavior*:
    alreadyHaveRunLast = false
    for behavior in unordered:
      for precedenceRule in behavior.PrecedenceRules:
        if precedenceRule.Precedence == Precedence.RunLast:
          raise MultipleRunLastBehaviorsException() if alreadyHaveRunLast
          alreadyHaveRunLast = true
          ordered.Add(behavior)
    return ordered