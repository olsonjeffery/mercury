namespace Mercury.Core

import System

public class PrecedenceRule:
  
  _targetName as string
  _precedence as Precedence
  
  def constructor(targetName as string, precedence as Precedence):
    _targetName = targetName
    _precedence = precedence
  
  Precedence as Precedence:
    get:
      return _precedence
  TargetName as string:
    get:
      return _targetName
