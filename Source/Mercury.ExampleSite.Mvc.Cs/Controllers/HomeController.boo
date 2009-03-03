
namespace MvcApplication1.Controllers

import System
import System.Collections.Generic
import System.Linq
import System.Web
import System.Web.Mvc

[HandleError]
public class HomeController(Controller):

	public def Index() as ActionResult:
		ViewData['Message'] = 'Welcome to ASP.NET MVC!'
		
		return View()

	
	public def About() as ActionResult:
		return View()

