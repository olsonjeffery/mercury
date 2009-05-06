namespace Mercury.Specs

import System
import System.Web

public class TestHttpContext(HttpContextBase):
"""Description of TestHttpContext"""
  public def constructor():
    _request = TestHttpRequest("http://foo.com", "GET")
    _response = TestHttpResponse()
  
  public def constructor(request as HttpRequestBase, response as HttpResponseBase):
    _request = request
    _response = response
  
  _response as HttpResponseBase
  public override Response as HttpResponseBase:
    get:
      return _response
  
  public def SetResponse(response as HttpResponseBase):
    _response = response
  
  _request as HttpRequestBase
  public override Request as HttpRequestBase:
    get:
      return _request
  
  public def SetRequest(request as HttpRequestBase):
    _request = request
