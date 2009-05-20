namespace Mercury.ExampleSite.Domain

import System
import System.Collections.Generic

public interface ITestService:
  def GetSomeString() as string

public class TestService(ITestService):
  def GetSomeString() as string:
    return "ITestService works!"