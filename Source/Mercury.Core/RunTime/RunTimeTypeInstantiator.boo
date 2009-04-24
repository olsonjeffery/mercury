namespace Mercury.Core

import System
import System.Reflection
import System.Web
import Microsoft.Practices.ServiceLocation

public class RunTimeTypeInstantiator:
  
  _container as IServiceLocator
  
  public def constructor(container as IServiceLocator):
    _container = container

  public def GetConstructorWithMostParametersFor(type as Type) as ConstructorInfo:
    ctor as ConstructorInfo = null
    ctorParamsCount = 0
    for i in type.GetConstructors():
      ctorParamsCount = (List of ParameterInfo(ctor.GetParameters())).Count unless ctor == null
      iParamsCount = (List of ParameterInfo(i.GetParameters())).Count
      ctor = i if ctor is null or ctorParamsCount < iParamsCount
    raise "no constructor found for type: "+type.ToString() if ctor is null
    return ctor
  
  public def GetDependenciesForConstructor(ctor as ConstructorInfo) as object*:
    deps = []
    for i in ctor.GetParameters():
      dep = _container.GetInstance(i.ParameterType)
      deps.Add(dep)
    return deps
  
  public def CreateInstanceOf(type as Type) as IMercuryRouteAction:
    //ctor = GetConstructorWithMostParametersFor(type)
    //deps = GetDependenciesForConstructor(ctor)
    //return (ctor.Invoke((List of object(deps)).ToArray()) as IMercuryRouteAction)
    return CreateInstanceOf[of IMercuryRouteAction](type)
  
  public def CreateInstanceOf[of TType](type as Type) as TType:
    ctor = GetConstructorWithMostParametersFor(type)
    deps = GetDependenciesForConstructor(ctor)
    return (ctor.Invoke((List of object(deps)).ToArray()) as TType)
  
  public def CreateInstancesOfBehaviorsFrom(behaviorTypes as Type*) as IBehavior*:
    list = List of IBehavior()
    for i in behaviorTypes:
      behavior = CreateInstanceOf[of IBehavior](i)
      list.Add(behavior)
    return list