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
    return true if behaviors.Select(_selectNames).Contains(_targetName) and _precedence == Precedence.RunAfter
    //return true if not behaviors.Select(_selectNames).Contains(_targetName) and _precedence == Precedence.RunBefore
    return true if _precedence == Precedence.RunBefore
    
    return false
  
  public virtual def LocationToBeAddedToIn(behaviors as IBehavior*) as int:
    raise "Cannot find location in behaviors that this precedence rule is NOT satisfied by" if not IsSatisfiedBy(behaviors) and not _precedence == Precedence.RunBefore
    return -1 if _precedence == Precedence.RunAfter
    
    ordered = List of IBehavior(behaviors)
    for i in range(0, behaviors.Count()):
      continue if i == behaviors.Count()
      behavior = ordered[i]
      behaviorName = (behavior.GetType().FullName if _targetName.Contains('.') else behavior.GetType().Name)
      //raise behaviorName + " - " + _targetName
      return (i) if behaviorName == _targetName and _precedence == Precedence.RunBefore
    return -1 if not behaviors.Select(_selectNames).Contains(_targetName) and _precedence == Precedence.RunBefore
    
    raise "unable to find location for precedence rule!"