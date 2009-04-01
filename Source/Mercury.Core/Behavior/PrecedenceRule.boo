namespace Mercury.Core

import System

public class PrecedenceRule:
  
  _targetName as string
  _precedence as Precedence
  
  def constructor(targetName as string, precedence as Precedence):
    _targetName = targetName
    _precedence = precedence
  
  public Precedence as Precedence:
    get:
      return _precedence
  public TargetName as string:
    get:
      return _targetName
