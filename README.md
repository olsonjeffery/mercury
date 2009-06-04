## Mercury: A different perspective on ASP.NET web frameworks

Mercury is a web framework built atop [ASP.NET](http://www.asp.net/) and [ASP.NET MVC](http://www.asp.net/mvc). It is written primarily in [Boo](http://boo.codehaus.org). It provides an [internal DSL](http://martinfowler.com/bliki/DomainSpecificLanguage.html) meant to streamline the process of composing a route-based web application that is not only easier on the eyes and wrists, but is also sustainable and maintainable. Mercury draws its inspiration from the ruby-based [Sinatra](http://www.sinatrarb.com) web framework. That being said, there are a number of non-trivial differences between the two, having much to do with the idiosyncrasies of their respective backing architectures and the fact that Ruby is a dynamic language while Boo is statically typed.

Mercury is released under the terms of the [MIT License](http://www.opensource.org/licenses/mit-license.php). It is kept under source control at <http://github.com/olsonjeffery/mercury>.

A great big thanks to the developers behind the [Sinatra](http://www.sinatrarb.com) project for providing the inspiration for this framework. Thanks also to the team behind [Boo](http://boo.codehaus.org), particularly Cedric Vivier, who provided a quick fix to a blocking ASP.NET code generation issue early-on. Without this great language, the opportunity to work on such a project wouldn't exist in the same form.

### Why Mercury?

It's become apparent that, in the course developing web applications in ASP.NET that happen to have both a rich domain (where all of the business logic besides mapping from the client to the domain and vice versa is pushed into application services and *not* present in the server-side web layer) and a rich client (where the UI doesn't take orders from the server as much as merely poll it for data needed to drive it's own client-side logic and push data to it when needed), there is pretty narrowly focused set of tasks that web frameworks are best suited to and should be optimized for.

The tasks mentioned above are:

* Expose endpoints (*Routes*) and handlers (*Actions*) for them which the client can hit to GET a view, POST information, etc. Additionally specify *Behaviors* that target all or a specific subset of these routes to accomplish administrative tasks (user authentication, logging, etc) that would only add repetition and clutter to the route actions themselves.
* Deliver application dependencies to the handler for a route to aid the handler in carrying out its mission.
* Map data from the client to the domain and vice versa.

With these points in mind, it's easy to envision a world where the actual server-side web component of an application stack is somewhat anemic. Adding new routes and sections to a web application should be as easy as declaring a route and what ought to happen when a request that matches this route is received from the client. Yet, this doesn't seem to be the case in practice.

Mercury is a web framework that attempts to address this and other concerns. The third item in the above list is highly domain-dependent, so Mercury is mostly concerned with optimizing the first two. Additionally, the second item seems to be a greater concern in statically typed programming languages, a group which Boo counts itself among.

### A Mercury hello world!

In order to understand how Mercury can make the web application aspect of your software developer life easier, let's start with some code:

    Get "/":
      return "Hello, world!"

This demonstrates the basic unit of externally exposed functionality in a Mercury web application: The route action. It has two major components: The *Route* portion, which consists of an HTTP Method (`GET`, `PUT`, `POST` and `DELETE` are supported) and a route string (the url-like portion that is between double-quotes). The other part of this route action is the *Action body*, or just *action*. It is the entire indented block that comes after `Get "/"`. This is the code that is evaluated when it's enclosing route is matched.

The code block shown is a route that matches to `"/"` or `""` (the default page for the site.. for example it'd match a call to `http://www.example.com/` from the browser). The content of the route action's body is to write `Hello, world!` directly to the output of the response (returning a string from an action body in mercury will cause that string to be written to the output). Let's show how much code this would take in an equivalent ASP.NET MVC app composed in everyone's favorite language, C#:

In your `Application_Start()`, you'd need...

    routes.MapRoute(
        "Default",                                              // Route name
        "{controller}/{action}/{id}",                           // URL with parameters
        new { controller = "Home", action = "Index", id = "" }  // Parameter defaults
    );

...in order to register the default routing scheme (controller/action convention and call `HomeController.Index()` by default).

Then, in your `HomeController` class, you'd need:

    public ActionResult Index()
    {
      ControllerContext.HttpContext.Response.Output.Write("Hello,  world!");
      return null;
    }

.. or something along those lines. And this is just a trivial example. 

Even with the fact that adding the default route is a one time cost, this is still noisier than the Mercury Example. There's also the higher-level design concern of "tearing apart" a route from its action. When used off of the shelf, ASP.NET MVC wants all of the routes set up in a centralized fashion, as opposed to being located with the controllers/actions themselves. And while the controller/action convention that is prevalent in ASP.NET "MVC" solutions (FubuMVC, ASP.NET MVC and MonoRail, particularly) is more than satisfactory for most "entry-level" MVC apps, you'll soon find yourself adding routes as soon you start wanting prettier "REST-ful" style routes, like:

    // In ASP.NET MVC, this action won't match on `http://example.com/User/foo` unless 
    // you added a route during `Application_Start()`. Within a specific route, this 
    // would only match on `http://example.com/User/Index?username=foo`.
    public ActionResult Index(string username)
    {
      ...
    }

Mercury is philosophically opposed to the "implicit routing" prominent in other modern ASP.NET frameworks. Instead, it puts the onus on developers to declare the route for each action explicitly from the get-go. This is a feature and not a bug.

### Getting started with Mercury

The Mercury codebase provides a Mercury.ExampleSite ASP.NET project which is a good place to start. It is broken down as follows:

* `Global.asax` and `Global.asax.boo` -- The `.boo` codebehind houses the `Application_Start()` that gets ran when an ASP.NET app starts up. Here is where you do your setup for your container of choice (any container that has an adapter for `IServiceLocator` is supported, as discussed in the "Inversion of Control Containers in Mercury" section of this document. This is also where you add/configure any view engines you'd like to use. Mercury currently has wrappers for the Spark and NHaml view engines. The example site shows how to add support for both of them. This is also where the `MercuryStartupService` is instantiated and it's `BuildRoutes()` method is called. The return value of that method should then be added to the static RouteTable as shown in ExampleSite.
* The `Scripts` and `Content` folders -- These are default folders from ASP.NET MVC used to house javascript files and CSS/images, respectively. Their use is [already documented](http://forums.asp.net/p/1379069/2910449.aspx#2910449). 
* The 'Views' folder -- like Scripts/Context, this is also a convention-based folder from ASP.NET MVC. This is the default "root" folder where all view files should live. Whenever using Mercury's view engine rendering macros (`spark` or `nhaml`, currently), it is assumed that the files are within this folder (so if you have a file in `AppRoot\Views\NHaml\Index.haml`, you will use it at render time as `nhaml "NHaml/Index.haml"` -- also note the use of forward-slashes when specifying the URI for the view file.
* The `Routes` folder -- this folder houses all of the Mercury route actions. Mercury is unique amongst ASP.NET frameworks in that it tightly couples the routes and their implementation action bodies instead of splitting them up, presentationally. The route actions are located in the same project as the web site itself; this is by convention only and nothing is stopping you from moving these routes to another project, as long as the assembly containing the routes is referenced by the ASP.NET site. All referenced assemblies as searched at startup for Mercury route actions. Additionally, the Behaviors that target the various routes are housed alongside the routes, themselves. This is another convention-based choice and nothing says you can't put them in other files or projects, as they are parsed/loaded at startup in the same manner as routes.
* The `Domain` folder -- another convention-based choice. In a real web site you will most likely house the domain in an external project. This is provided for organizational convenience, only.
* The `web.config` for this project has an added dependency on the `Boo.Lang.CodeDom` code generator.

### Some more on routes and routing in Mercury

One caveat to the the above `Hello, world!` example: Because `get` is a reserved keyword in Boo, you must use the Uppercase-G with GET routes. This is not required for the other verbs (`Post`, `Put`, `Delete`). Also, `GET` is an acceptable substitute, if you that's your thing.

Currently, Mercury uses the [System.Web.Routing](http://msdn.microsoft.com/en-us/library/system.web.routing.route.aspx) engine to parse and match on its routes. With this in mind, routes are defined in conformance to System.Web.Routing's standards *with the exception* of defining the default route for the root of a site. Typically, beginning a route with a `/` character is not allowed, but Mercury allows it for the *default route only*, because it much more intention-revealing than having a route that matches on an empty string.

#### Ways to return a result from a route's body without rendering a view
a
If you'd like to turn an arbitrary .NET object into JSON, it's as simple as:

     Get "summary/{username}":
      dependency summaryService as IUserSummaryService 
      userSummary = summaryService.GetSummaryFor(username)
      json userSummary

Of course, as noted in above examples, simply returning a string will cause that string to be written to the output:

     Get "hello/world":
       return "it's as simple as that!"

If you'd like to redirect to another route or URL, try:

    Get "should/we/redirect/{answer}":
      if answer.Equals('yes'):
        redirect "/target/url"
      else:
        return "nope.. no redirects here"

Should it, in the course of processing a route's body, become desirable to halt execution and return an http error, you can do:

    Get "something/goes/wrong":
      rand = Random()
      if rand.Next(0,100) > 50:
        halt 500
      else:
        return "less than 50"

You can also add an optional message to be returned in the output and error status description:

    Get "something/goes/wrong":
      rand = Random()
      if rand.Next(0,100) > 50:
        halt 500, "Looks like it was greater than 50, to me"
      else:
        return "less than 50"

You can also return sub-status codes:

    Get "something/goes/wrong":
      rand = Random()
      if rand.Next(0,100) > 50:
        halt 500.13, "web server too busy"
      else:
        return "less than 50"

Of course, if you'd like to return *nothing at all* from your method's route body, that's fine as well. Boo's compiler will just slip in a `return null` statement for you at the end to keep things kosher. `null` results are ignored by the framework.

#### `not_found`: handling for a malformed route

If you'd like to have a route action that is processed when a request's url doesn't match on any existing route, you can define a `not_found` route action like so:

    not_found:
      return "route not found, sorry."

And this route action will be processed in the event that the URL of a request doesn't match an existing route or resource. Please note that, because of the default scheme for mapping resources for the `Scripts`, `Content` and `Views` folders in an ASP.NET project, malformed requests in these URI-spaces *won't* be handled by a `not_found` route action.

#### Reserved keywords and default local variables in Mercury

Out-of-the-box, Mercury will set up several default local variables for various useful things in that you'll want to have handy in the route's body.

For every parameter you declare for a route (using `{param_name}` syntax), Mercury will declare a matching local variable with the same name as your parameter and populate it with the value in the request as a string. You can also, optionally, use the `params` object to access route parameters using the typical string indexor or a IQuackFu-based approach, like so:

    Get "route/{parameter_name}":
      if parameter_name in (parameter_name, params["parameter_name"], params.parameter_name):
        return "they all point to the same string. neat, huh?"

In the above example, the `params` object is read only. Do not attempt to store variables in it.

The `views` and `temp` variables are, on the other hand, read/write:

    Get "route/{parameter_name}":
      view.parameter_name = parameter_name
      temp.parameter_name = view["parameter_name"]

`view` and `temp` are wrappers around the `ViewData` and `TempData` properties of ControllerBase from ASP.NET MVC, respectively.

If you need more low-level access to a request, response, etc.. you can always use the `self.ControllerContext` property to get that underlying access. It behaves exactly as it does in ASP.NET MVC.

Here's a non-exhaustive list of reserved identifiers/keywords in Mercury:

* Macros for declaring routes, behaviors, etc: `Get`, `Post`, `Put`, `Delete`, `Any` and `not_found`. `Behavior` for declaring behaviors. `dependency` to declare a new dependency in a macro body or behavior.
* `params`, `view` and `temp` in the route body.
* For every parameter delcared withing curly braces, like `{parameterName}`, a local variable (as a `string`) is declared in the Route body's scope.

### Dependency Injection in Mercury

Any modern, non-trivial ASP.NET application that isn't a WebForms ball-of-mud is going to want to provide a [Dependency Injection](http://en.wikipedia.org/wiki/Dependency_injection) solution for it's exposed actions, sooner or later. 

#### Injecting dependencies into Mercury route actions

In ASP.NET land, the typical pattern to accomplish this is to declare dependencies in the constructor for a controller class and have some method at the web framework level to inject those dependencies into an instance of the controller at the time of a client request. This approach can lead to the instinctual tendency to aggregate actions with similar dependency requirements that don't necessarily belong together from a site layout/behavioral standpoint. With a sufficiently complex feature, a controller's size in code and scope can quickly get out of control.

Mercury handles for this case as a core feature. Consider the following:

    Post "Widgets/MoveWidgets/{fromShelf}/{toShelf}/{amount}":
      dependency widgetServices as IWidgetServices
      widgetServices.MoveWidgets(fromShelf, toShelf, amount)
      redirect "Widgets/Summary"

    Get "Widgets/Summary":
      dependency widgetReporter as IWidgetReporter
      view.WidgetsSummary = widgetsReporter.WhereAreTheWidgets()
      spark "Widgets/Summary"

Now, there's a lot of interesting things going on in this example. But let's concentrate on the first line of the first route action's body:

    dependency widgetServices as IWidgetServices

It's pretty obvious what's going on here, right? The route action states, up front, that it has a dependency on a IWidgetServices and it'd like the instance of that service to be called widgetServices. What's interesting here that the two routes don't share any dependencies, in this case. If this were an ASP.NET MVC project, it'd look something like:

    public class AccountController : Controller
    {
      IWidgetServices _widgetServices;
      IWidgetReporter _widgetReporter;
    
      public WidgetsController(IWidgetServices widgetServices, IWidgetReporter widgetReporter)
      {
        _widgetServices = accountServices;
        _widgetReporter = accountReporter;
      }
    
      public ActionResult MoveWidgets(int fromShelf, int toShelf, decimal amount)
      {
        _widgetServices.MoveWidgets(fromShelf, toShelf, amount);
        return Redirect("Widgets/Summary");
      }
    
      public ActionResult Summary()
      {
        ViewData["WidgetsSummary"] = _widgetReporter.WhereAreTheWidgets();
        return View();
      }
    }

There are, primarily, two things worth noting about this C# example: First, compared to the Mercury example, it's quite noisy with all the setup code that goes into establishing dependencies and whatnot. Second, the two actions (`MoveWidgets` and `Summary`) share all of their dependencies, even though each one doesn't use the other's. A third and somewhat tangential issue is that `MoveWidgets` doesn't have a more REST-ful looking route out-of-the-box and is going to require a route to be registered during `Application_Start()`. This is the last time that this shortcoming will be mentioned, honest :)

For the record, Mercury implements its DI scheme in a manner very similar to how other ASP.NET frameworks declare dependencies: the constructor. At compile-time (expansion-time, technically), the code for each route action turns into an AST and is transformed into an AST for a class definition. It is this class that has the dependencies declared as parameters to its constructor. From here, the DI is done in a manner pretty much the same as other frameworks. Overall, the end results are the same. It's just that Mercury is much less noisy about it.

#### Inversion of Control containers in Mercury

But all of this doesn't even take into the account the need to setup a mechanism which, presumably, is going to do the actual heavy-lifting of delivering the required dependencies to your controller at the time of a client request. In Mercury, this is accomplished through the use of [any](http://www.castleproject.org/container/gettingstarted/index.html) [number](http://structuremap.sourceforge.net/Default.htm) [of](http://www.codeplex.com/unity) [different](http://github.com/machine/machine/tree/master) [Inversion of Control](http://ninject.org/) [containers](http://www.springframework.net/news.html). Mercury only requires that the container implementation you use has an adapter that satisfies the [IServiceLocator](http://www.codeplex.com/CommonServiceLocator) interface. Mercury's ExampleSite uses [Machine.Container](http://github.com/machine/machine/tree/master), but this doesn't stop you from using any other container if you so desire.

In order to demonstrate how Mercury integrates with an IoC container, let's just show the code.

In a Mercury project's Global.asax:

    public class MercuryApplication(System.Web.HttpApplication):  
      protected static def ConfigureContainer() as IServiceLocator:
        container = SomeContainerImpl()

        // container configuration, registration of deps, etc goes here.

        return container  
        // or whatever it takes to get an IServiceLocator for your container of choice

      public static def ConfigureMercuryEngine() as Route*: // Factoid: T* is Boo shorthand for IEnumerable[of T]
        container = ConfigureContainer()
        engine = MercuryStartupService(container, ViewEngines.Engines)
        routes = engine.BuildRoutes()
        for route in routes:
          RouteTable.Routes.Add(route.Url, route)
        return routes
      
      protected def Application_Start():
        ConfigureMercuryEngine()

In this example, you can see how the `MercuryStartService` takes an `IServiceLocator` in its constructor. It will use the container during client requests to satisfy the dependencies for routes. With this in mind, you (the developer) just have to make sure to register the dependencies and Mercury will take of the rest. That's all there is to it, really.

In ASP.NET MVC, not so much. The main annoyance is that you'll have to provide an implementation of `IControllerFactory` that does the actual work of resolving controller instances with dependencies at runtime. This isn't such a big deal, but it's still an inconvenience. Other frameworks are kind enough to have the concept of a container baked in, but make the design mistake (in the author's opinion) of tightly coupling the framework to a single container implementation (you know who you are).

### Behaviors in Mercury

Like most other ASP.NET frameworks, Mercury has a concept of *Behaviors* (known as filters in some other frameworks).

A demonstration, if you will:

    behavior AuthenticatedUsersOnly:
      target ".*"
      target_not "Public"
      target_not "User/Login"
      dependency userAuthService as IUserAuthenticationService
      before_action:
        redirect "User/Login" if not userAuthService.sessionIsAuthentication(controllerContext.HttpContext.Session)
    
    Get "User/Login":
      // login stuff goes here
      pass
    
    Get "User/Summary":
      // user summary goes here
      pass

A few things worth mentioning in this example:

1. The behavior has a name. Any name for a valid identifier (it actually expands into a class) is allowed. This is so that behaviors can associate themselves with each other (an idea which will be expanded up very shortly). 

1. Second, the behavior *targets* a specific subset of routes, as determined by the provided regular expression string that accompanies the `target` statement. A behavior *must* provide at least one `target` statement, but can provide as many as it wants if need be. If you want your behavior to target all routes, just have it target '`.*`'. This is important to note, because behaviors are parsed globally, regardless of where they're located. Bear this in mind when defining the `target`(s) for a route. `target_not` is a simple inversion of the `target` concept: a route that matches `target_not` will be *excluded* from the subset of targeted routes. Please be aware that `target_not` takes precedence over `target`. This is to help you, the developer, keep your targets relatively simple and intention-revealing (as opposed to being laden with write-only regular expressions).

1. Third, the behavior has a `before_action` block that is pretty self-explanatory. An `after_action` is also supported. Also, as you can see, the `before_action` has a call to a local variable called `controllerContext`. This is an instance of the ASP.NET MVC [ControllerContext](http://msdn.microsoft.com/en-us/library/system.web.mvc.controllercontext.aspx), which provides access to the request and response, amongst other things. The `after_action` blocks also gets a shot at the object returned as the *result* of the route, in addition to the `ControllerContext`. 

1. Fourth, behaviors can take dependencies just like route actions. 

1. Finally, the behavior does a redirect if the client making the request is not authenticated. From this we can see that behaviors can effect the course of a request in much the same ways a route action can.

To expand upon the utility of the first item mentioned above:

    behavior AuthenticatedUsersOnly:
      target_not "Public"
      target_not "User/Login"
      dependency userAuthService as IUserAuthenticationService
      before_action:
        redirect "User/Login" if not userAuthService.sessionIsAuthentication(controllerContext.HttpContext.Session)
        view.username = controllerContext.HttpContext.Session["username"]
    
    behavior FetchUserInfo:
      target ".*"
      target_not "Public"
      target_not "User/Login"
      run_after AuthenticatedUsersOnly
      dependency userInfo as IUserInfoService
      before_action:
        view.UserInfo = userInfo.GetFor(view.username)
    
    behavior LogStuff:
      dependency log as ILogger
      run_last
      target ".*"
      after_action:
        pass // logging stuff goes here

What's worth pointing out, here? In the second behavior, `FetchUserInfo`, there is a `run_after` statement that says quite plainly that the behavior should run after `AuthenticatedUsersOnly`. 

The behavior is declaring its *precedence* in relation to another behavior. `run_before` is also supported. With this, you can construct dependency sequences of behaviors for a given set of routes. It should be noted, however, that an exception will be thrown at startup if a given behavior has a precedence relationship with another behavior that *does not* target the same set of routes. Cyclic precedence relationships will also cause an exception. Please bear this in mind when setting up your behaviors. 

Also, interestingly, the `LogStuff` behavior has a `run_last` statement. This does what you might expect. There is also a `run_first` statement. An exception will be thrown on startup if a given route has more than one `run_first` or `run_last` behavior targeting it.

### Rendering views in Mercury

Currently, Mercury supports rendering views defined in [NHaml](http://code.google.com/p/nhaml/) and [Spark](http://dev.dejardin.org/). [Brail](http://www.castleproject.org/monorail/documentation/trunk/viewengines/brail/gettingstarted.html) support is planned.

Render semantics work like:

    Get "nhaml\helloworld":
      nhaml "nhaml\foo.haml"

    Get "spark\helloworld":
      spark "spark\foo.spark"

The mentioned early in the document, the provided paths in these example route actions would map to `AppRoot\Views\nhaml\foo.haml` and `AppRoot\Views\spark\foo.spark`, respectively. Please be mindful that, if you're going to use Mercury's view engine wrappers, you'll want to add the view engines on startup:

    protected static def ConfigureViewEngines() as ViewEngineCollection:
      ViewEngines.Engines.Add(MercurySparkViewEngine())
      ViewEngines.Engines.Add(MercuryNHamlViewEngine())
      return ViewEngines.Engines

... This is the fashion in which it is done in Mercury.ExampleSite. Note that Mercury provides wrapper classes for NHaml and Spark's own view engines implementations.