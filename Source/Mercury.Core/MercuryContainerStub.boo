namespace Mercury.Core

import System
import Microsoft.Practices.ServiceLocation

public class MercuryContainerStub(IServiceLocator):
  public def constructor():
    pass
  
  public def GetService(type as Type) as object:
    raise ActivationException()
  
  public def GetInstance(serviceType as Type) as object:
    raise ActivationException()
  
  public def GetInstance(serviceType as Type, key as string) as object:
    raise ActivationException()
  
  public def GetAllInstances(serviceType as Type) as object*:
    raise ActivationException()

  public def GetInstance[of TService]() as TService:
    raise ActivationException()
  
  public def GetInstance[of TService](key as string) as TService:
    raise ActivationException()
  
  public def GetAllInstances[of TService]() as TService*:
    raise ActivationException()