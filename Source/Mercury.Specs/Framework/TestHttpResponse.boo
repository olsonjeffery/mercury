namespace Mercury.Specs

import System
import System.IO
import System.Web

public class TestHttpResponse(HttpResponseBase):
  public def constructor():
    _output = StreamWriter(MemoryStream())
  
  _output as TextWriter
  public override Output:
    get:
      return _output
  
  public def SetOutput(output as TextWriter):
    _output = output