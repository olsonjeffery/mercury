namespace Mercury.Routing

import System
import System.Web
import System.Security.Permissions

[AspNetHostingPermission(SecurityAction.LinkDemand, Level:AspNetHostingPermissionLevel.Minimal), AspNetHostingPermission(SecurityAction.InheritanceDemand, Level:AspNetHostingPermissionLevel.Minimal)]
public class MercuryRoutingModule(IHttpModule):
"""Description of MercuryRoutingModule"""
  public def constructor():
    pass
  
  public virtual def Init(application as HttpApplication) as void:
    pass
  
  public virtual def Dispose() as void:
    pass