namespace Mercury.Specs

import System
import System.Web

public class HttpContextCreator(FixtureService[of HttpContextBase]):
"""Description of HttpContextCreator"""
  public def constructor():
    Creation = TestHttpContext(TestHttpRequest(), TestHttpResponse())

