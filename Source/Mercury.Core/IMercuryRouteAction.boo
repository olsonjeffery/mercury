namespace Mercury.Core

public interface IMercuryRouteAction:
  def Execute()
  RouteString as string:
    get
  HttpMethod as string:
    get
  
