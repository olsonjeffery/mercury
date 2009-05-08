namespace Mercury.Core

import System
import System.IO

public class BehaviorResultProcessor:
  
  public def constructor():
    pass
    
  public virtual def ProcessNullResult() as void:
    pass
  
  public virtual def ProcessIRouteResult(result as IRouteResult):
    result.ProcessResult()
  
  public virtual def ProcessStringResult(input as string, output as TextWriter):
    output.Write(input)