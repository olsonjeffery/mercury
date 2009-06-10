namespace Mercury.Routing

import System
import System.Collections.Generic
import Mercury.Core

public class RouteData:
  
  [Property(Values)]
  _values as Dictionary[of string, string]
  
  [Property(Handler)]
  _handler as MercuryRouteHandler
  
  public def constructor(values as Dictionary[of string, string], handler as MercuryRouteHandler):
    Values = values
    Handler = handler