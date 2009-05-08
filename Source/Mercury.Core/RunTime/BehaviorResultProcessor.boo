namespace Mercury.Core

import System
import System.IO

public class BehaviorResultProcessor:
  
  public def constructor():
    pass
  
  public virtual def ProcessStringResult(input as string, output as TextWriter):
    output.Write(input)