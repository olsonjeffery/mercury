namespace Mercury.Core

import System
import Boo.Lang.Compiler.Ast

public class UnknownRuleInBehaviorException(Exception):
"""Description of UnknownRuleInBehaviorException"""
  def constructor(statement as Statement, behaviorName):
    super("Unknown rule in behavior "+behaviorName+": '" + statement.ToCodeString() + "'")

