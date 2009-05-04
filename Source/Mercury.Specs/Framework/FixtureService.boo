namespace Mercury.Specs

import System

public class FixtureService[of T]:

  public def constructor():
    pass
  
  [property(Creation)]
  _creation as T
  
  public static def op_Implcit(foo as FixtureService[of T]) as T:
    return foo.Creation