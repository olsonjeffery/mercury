
namespace MvcApplication1.Controllers

import System
import System.Collections.Generic
import System.Globalization
import System.Linq
import System.Security.Principal
import System.Web
import System.Web.Mvc
import System.Web.Security
import System.Web.UI


[HandleError]
public class AccountController(Controller):

	
	// This constructor is used by the MVC framework to instantiate the controller using
	// the default forms authentication and membership providers.
	
	public def constructor():
		self(null, null)

	
	// This constructor is not used by the MVC framework but is instead provided for ease
	// of unit testing this type. See the comments at the end of this file for more
	// information.
	public def constructor(formsAuth as IFormsAuthentication, service as IMembershipService):
		FormsAuth = (formsAuth or FormsAuthenticationService())
		MembershipService = (service or AccountMembershipService())

	
	public FormsAuth as IFormsAuthentication:
		get:
			pass
		private set:
			pass

	
	public MembershipService as IMembershipService:
		get:
			pass
		private set:
			pass

	
	public def LogOn() as ActionResult:
		
		return View()

	
	[AcceptVerbs(HttpVerbs.Post)]
	[System.Diagnostics.CodeAnalysis.SuppressMessage('Microsoft.Design', 'CA1054:UriParametersShouldNotBeStrings', Justification: 'Needs to take same parameter type as Controller.Redirect()')]
	public def LogOn(userName as string, password as string, rememberMe as bool, returnUrl as string) as ActionResult:
		
		if not ValidateLogOn(userName, password):
			ViewData['rememberMe'] = rememberMe
			return View()
		
		FormsAuth.SignIn(userName, rememberMe)
		if not String.IsNullOrEmpty(returnUrl):
			return Redirect(returnUrl)
		else:
			return RedirectToAction('Index', 'Home')

	
	public def LogOff() as ActionResult:
		
		FormsAuth.SignOut()
		
		return RedirectToAction('Index', 'Home')

	
	public def Register() as ActionResult:
		
		ViewData['PasswordLength'] = MembershipService.MinPasswordLength
		
		return View()

	
	[AcceptVerbs(HttpVerbs.Post)]
	public def Register(userName as string, email as string, password as string, confirmPassword as string) as ActionResult:
		
		ViewData['PasswordLength'] = MembershipService.MinPasswordLength
		
		if ValidateRegistration(userName, email, password, confirmPassword):
			// Attempt to register the user
			createStatus as MembershipCreateStatus = MembershipService.CreateUser(userName, password, email)
			
			if createStatus == MembershipCreateStatus.Success:
				FormsAuth.SignIn(userName, false)
				/* createPersistentCookie */
				return RedirectToAction('Index', 'Home')
			else:
				ModelState.AddModelError('_FORM', ErrorCodeToString(createStatus))
		
		// If we got this far, something failed, redisplay form
		return View()

	
	[Authorize]
	public def ChangePassword() as ActionResult:
		
		ViewData['PasswordLength'] = MembershipService.MinPasswordLength
		
		return View()

	
	[Authorize]
	[AcceptVerbs(HttpVerbs.Post)]
	[System.Diagnostics.CodeAnalysis.SuppressMessage('Microsoft.Design', 'CA1031:DoNotCatchGeneralExceptionTypes', Justification: 'Exceptions result in password not being changed.')]
	public def ChangePassword(currentPassword as string, newPassword as string, confirmPassword as string) as ActionResult:
		
		ViewData['PasswordLength'] = MembershipService.MinPasswordLength
		
		if not ValidateChangePassword(currentPassword, newPassword, confirmPassword):
			return View()
		
		try:
			if MembershipService.ChangePassword(User.Identity.Name, currentPassword, newPassword):
				return RedirectToAction('ChangePasswordSuccess')
			else:
				ModelState.AddModelError('_FORM', 'The current password is incorrect or the new password is invalid.')
				return View()
		except :
			ModelState.AddModelError('_FORM', 'The current password is incorrect or the new password is invalid.')
			return View()

	
	public def ChangePasswordSuccess() as ActionResult:
		
		return View()

	
	protected override def OnActionExecuting(filterContext as ActionExecutingContext):
		if filterContext.HttpContext.User.Identity isa WindowsIdentity:
			raise InvalidOperationException('Windows authentication is not supported.')

	
	#region Validation Methods
	
	private def ValidateChangePassword(currentPassword as string, newPassword as string, confirmPassword as string) as bool:
		if String.IsNullOrEmpty(currentPassword):
			ModelState.AddModelError('currentPassword', 'You must specify a current password.')
		if (newPassword is null) or (newPassword.Length < MembershipService.MinPasswordLength):
			ModelState.AddModelError('newPassword', String.Format(CultureInfo.CurrentCulture, 'You must specify a new password of {0} or more characters.', MembershipService.MinPasswordLength))
		
		if not String.Equals(newPassword, confirmPassword, StringComparison.Ordinal):
			ModelState.AddModelError('_FORM', 'The new password and confirmation password do not match.')
		
		return ModelState.IsValid

	
	private def ValidateLogOn(userName as string, password as string) as bool:
		if String.IsNullOrEmpty(userName):
			ModelState.AddModelError('username', 'You must specify a username.')
		if String.IsNullOrEmpty(password):
			ModelState.AddModelError('password', 'You must specify a password.')
		if not MembershipService.ValidateUser(userName, password):
			ModelState.AddModelError('_FORM', 'The username or password provided is incorrect.')
		
		return ModelState.IsValid

	
	private def ValidateRegistration(userName as string, email as string, password as string, confirmPassword as string) as bool:
		if String.IsNullOrEmpty(userName):
			ModelState.AddModelError('username', 'You must specify a username.')
		if String.IsNullOrEmpty(email):
			ModelState.AddModelError('email', 'You must specify an email address.')
		if (password is null) or (password.Length < MembershipService.MinPasswordLength):
			ModelState.AddModelError('password', String.Format(CultureInfo.CurrentCulture, 'You must specify a password of {0} or more characters.', MembershipService.MinPasswordLength))
		if not String.Equals(password, confirmPassword, StringComparison.Ordinal):
			ModelState.AddModelError('_FORM', 'The new password and confirmation password do not match.')
		return ModelState.IsValid

	
	private static def ErrorCodeToString(createStatus as MembershipCreateStatus) as string:
		converterGeneratedName1 = createStatus
		// See http://msdn.microsoft.com/en-us/library/system.web.security.membershipcreatestatus.aspx for
		// a full list of status codes.
		if converterGeneratedName1 == MembershipCreateStatus.DuplicateUserName:
			return 'Username already exists. Please enter a different user name.'
		elif converterGeneratedName1 == MembershipCreateStatus.DuplicateEmail:
		
			return 'A username for that e-mail address already exists. Please enter a different e-mail address.'
		elif converterGeneratedName1 == MembershipCreateStatus.InvalidPassword:
		
			return 'The password provided is invalid. Please enter a valid password value.'
		elif converterGeneratedName1 == MembershipCreateStatus.InvalidEmail:
		
			return 'The e-mail address provided is invalid. Please check the value and try again.'
		elif converterGeneratedName1 == MembershipCreateStatus.InvalidAnswer:
		
			return 'The password retrieval answer provided is invalid. Please check the value and try again.'
		elif converterGeneratedName1 == MembershipCreateStatus.InvalidQuestion:
		
			return 'The password retrieval question provided is invalid. Please check the value and try again.'
		elif converterGeneratedName1 == MembershipCreateStatus.InvalidUserName:
		
			return 'The user name provided is invalid. Please check the value and try again.'
		elif converterGeneratedName1 == MembershipCreateStatus.ProviderError:
		
			return 'The authentication provider returned an error. Please verify your entry and try again. If the problem persists, please contact your system administrator.'
		elif converterGeneratedName1 == MembershipCreateStatus.UserRejected:
		
			return 'The user creation request has been canceled. Please verify your entry and try again. If the problem persists, please contact your system administrator.'
		else:
			
			return 'An unknown error occurred. Please verify your entry and try again. If the problem persists, please contact your system administrator.'
	#endregion


// The FormsAuthentication type is sealed and contains static members, so it is difficult to
// unit test code that calls its members. The interface and helper class below demonstrate
// how to create an abstract wrapper around such a type in order to make the AccountController
// code unit testable.

public interface IFormsAuthentication:

	def SignIn(userName as string, createPersistentCookie as bool)

	def SignOut()


public class FormsAuthenticationService(IFormsAuthentication):

	public def SignIn(userName as string, createPersistentCookie as bool):
		FormsAuthentication.SetAuthCookie(userName, createPersistentCookie)

	public def SignOut():
		FormsAuthentication.SignOut()


public interface IMembershipService:

	MinPasswordLength as int:
		get

	
	def ValidateUser(userName as string, password as string) as bool

	def CreateUser(userName as string, password as string, email as string) as MembershipCreateStatus

	def ChangePassword(userName as string, oldPassword as string, newPassword as string) as bool


public class AccountMembershipService(IMembershipService):

	private _provider as MembershipProvider

	
	public def constructor():
		self(null)

	
	public def constructor(provider as MembershipProvider):
		_provider = (provider or Membership.Provider)

	
	public MinPasswordLength as int:
		get:
			return _provider.MinRequiredPasswordLength

	
	public def ValidateUser(userName as string, password as string) as bool:
		return _provider.ValidateUser(userName, password)

	
	public def CreateUser(userName as string, password as string, email as string) as MembershipCreateStatus:
		status as MembershipCreateStatus
		_provider.CreateUser(userName, password, email, null, null, true, null, status)
		return status

	
	public def ChangePassword(userName as string, oldPassword as string, newPassword as string) as bool:
		currentUser as MembershipUser = _provider.GetUser(userName, true)
		/* userIsOnline */
		return currentUser.ChangePassword(oldPassword, newPassword)

