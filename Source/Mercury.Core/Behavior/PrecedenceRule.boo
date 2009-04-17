namespace Mercury.Core

import System
import System.Linq.Enumerable from System.Core

public class PrecedenceRule:
  
  _targetName as string
  _precedence as Precedence
  
  _selectNames = { behavior | (behavior.GetType().FullName if _targetName.Contains('.') else behavior.GetType().Name) }
  
  def constructor(targetName as string, precedence as Precedence):
    _targetName = targetName
    _precedence = precedence
  
  public virtual Precedence as Precedence:
    get:
      return _precedence
  public virtual TargetName as string:
    get:
      return _targetName
  
  public virtual def ConflictsWith(rule as PrecedenceRule) as bool:
    return true if self._targetName.Equals(rule.TargetName)
  
  public virtual def IsSatisfiedBy(behaviors as IBehavior*) as bool:
    return true if behaviors.Select(_selectNames).Contains(_targetName) and _precedence == Precedence.RunsAfter
    return true if not behaviors.Select(_selectNames).Contains(_targetName) and _precedence == Precedence.RunsBefore
    
    return false
  
  public virtual def LocationToBeAddedToIn(behaviors as IBehavior*) as int:
    raise "Cannot find location in behaviors that this precedence rule is NOT satisfied by" if not IsSatisfiedBy(behaviors)
    return -1 if _precedence == Precedence.RunsAfter
    
    ordered = List of IBehavior(behaviors)
    for i in range(0, behaviors.Count() -1):
      behavior = ordered[i]
      behaviorName = (behavior.GetType().FullName if _targetName.Contains('.') else behavior.GetType().Name)
      return (i-1) if behaviorName == _targetName and _precedence == Precedence.RunsBefore
    
    raise "unable to find location for precedence rule!"