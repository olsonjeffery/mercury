namespace Mercury.Core

import System
import System.Reflection
import System.Web
import Microsoft.Practices.ServiceLocation

public class RouteActionFactory:
  
  _container as IServiceLocator
  
  public def constructor(container as IServiceLocator):
    _container = container
  
  public def CreateMercuryRouteActionFromType(type as Type) as IMercuryRouteAction:
    raise "not impl"

  public def GetConstructorWithMostParametersFor(type as Type) as ConstructorInfo:
    ctor as ConstructorInfo = null
    ctorParamsCount = 0
    for i in type.GetConstructors():
      ctorParamsCount = (List of ParameterInfo(ctor.GetParameters())).Count unless ctor == null
      iParamsCount = (List of ParameterInfo(i.GetParameters())).Count
      ctor = i if ctor is null or ctorParamsCount < iParamsCount
    raise "no constructor found for type: "+type.ToString() if ctor is null
    return ctor