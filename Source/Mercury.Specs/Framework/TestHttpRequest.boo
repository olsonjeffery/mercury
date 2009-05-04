namespace Mercury.Specs

import System
import System.Web

public class TestHttpRequest(HttpRequestBase):

  _uri as Uri  
  public override Uri:
    get:
      return _uri
  
  _method as string
  public override HttpMethod:
    get:
      return _method
  
  public def constructor(url as string, httpMethod as string):
    _uri = Uri(url)
    _method = httpMethod
  
  

