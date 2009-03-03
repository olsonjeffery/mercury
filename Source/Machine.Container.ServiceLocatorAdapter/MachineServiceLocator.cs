using System;
using System.Collections.Generic;
using Microsoft.Practices.ServiceLocation;
using Machine.Container;

namespace Machine.Container.ServiceLocatorAdapter
{
  /// <summary>
  /// Description of MyClass.
  /// </summary>
  public class MachineServiceLocator : ServiceLocatorImplBase
  {
    MachineContainer _container;
    public MachineServiceLocator(MachineContainer container)
    {
      _container = container;
    }
    
    public MachineServiceLocator()
    {
      _container = new MachineContainer();
    }
    
    protected override IEnumerable<object> DoGetAllInstances(Type serviceType)
    {
      return _container.Resolve.All(serviceType);
    }
    
    protected override object DoGetInstance(Type serviceType, string key)
    {
      return _container.Resolve.Named(key);
    }
  }
}