namespace Mercury.Core

import System
import System.Web.Mvc
import System.Collections.Generic
import System.Linq.Enumerable from System.Core
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class MercuryRouteAstBuilder:
  private static _randomNumber as Random = Random()
  private _dependencyBuilder as DependencyAstBuilder
  private _constructorAndFieldAstBuilder as ConstructorAndFieldAstBuilder
  
  def constructor():
    _dependencyBuilder = DependencyAstBuilder()
    _constructorAndFieldAstBuilder = ConstructorAndFieldAstBuilder()
    
  public def BuildRouteClass(method as string, routeString as StringLiteralExpression, module as Module, body as Block) as ClassDefinition:
    rand = _randomNumber.Next()
      
    classDef = GetClassDefTemplate(method, routeString, body)
    
    rawDependencies = GetDependenciesForClass(body, module)
    
    routeBody = classDef.Members.Where({ x as TypeMember | x.Name == "RouteBody" }).Single() as Method
    classDef.Members.Remove(routeBody)
    newRouteBody = DoTransformationsOnRouteBody(routeBody, routeString.ToString(), rawDependencies)
    classDef.Members.Add(newRouteBody)
    
    classDef = PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef, rawDependencies)
    classDef.Name = classDef.Name + "_" + method + "_" + rand
    
    return classDef
  
  public def DoTransformationsOnRouteBody(routeBody as Method, routeString as string, rawDependencies as ParameterDeclaration*) as Method:
    
    excludeList = (i.Name for i in rawDependencies).ToList()
    
    oldBody = routeBody.Body
    
    newBody = Block()
    for i in oldBody.Statements:
      newBody.Statements.Add(i)
    
    routeValidator = RouteValidator()
    sanitizedRouteString = routeString.Trim().Replace("'", string.Empty)
    routeValidator.Validate(sanitizedRouteString)
    
    postParamsBody = ApplyParameterDeclarationsTo(newBody, routeString, excludeList)
    
    routeBody.Body = postParamsBody
    return routeBody
  
  public def ApplyParameterDeclarationsTo(body as Block, route as string, excludeList as string*) as Block:
    extractor = RouteParameterNameExtractor()
    params = extractor.GetParametersFrom(route)
    bodyWithParams = Block()
    
    typedLocals = List of DeclarationStatement()
    everythingElse = List of Statement()
    for statement as Statement in body.Statements:
      if statement isa DeclarationStatement and (statement as DeclarationStatement).Declaration.Name in excludeList:
        continue
      else:
        everythingElse.Add(statement)
    declaredParams = (DeclarationStatement(Declaration(i, [| typeof(string) |].Type), [| params.QuackGet($(StringLiteralExpression(i)), null) |]) for i in params).ToList()
    
    paramsCollection = ExpressionStatement([| params = RouteParameters(ControllerContext.RouteData.Values) |])
    viewCollection = ExpressionStatement([| view = ViewAndTempWrapper(ViewData) |])
    tempCollection = ExpressionStatement([| temp = ViewAndTempWrapper(TempData) |])
    bodyWithParams.Statements.Add(paramsCollection)
    bodyWithParams.Statements.Add(viewCollection)
    bodyWithParams.Statements.Add(tempCollection)
    for i in declaredParams:
      bodyWithParams.Add(i)
    for i in everythingElse:
      bodyWithParams.Add(i)
    return bodyWithParams
  
  public def GetDependenciesForClass(body as Block, module as Module) as ParameterDeclaration*:
    return _dependencyBuilder.GetDependenciesForClass(body, module)  
  
  public def PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef as ClassDefinition, rawDeps as ParameterDeclaration*) as ClassDefinition:
    return _constructorAndFieldAstBuilder.PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef, rawDeps)
  
  public def GetClassDefTemplate(method as string, routeString as StringLiteralExpression, body as Block) as ClassDefinition:
    classDef =  [|
      public class Mercury_route(MercuryControllerBase, IMercuryRouteAction):
        public def constructor():
          pass
        
        public override def RouteBody() as object:
          $(body)
        
        public HttpMethod as string:
          get:
            return $method
        
        public RouteString as string:
          get:
            return ("" if $routeString == "/" else $routeString)
        
        public HttpContext as HttpContextBase:
          get:
            return ControllerContext.HttpContext
        
        _viewEngines as ViewEngineCollection
        public ViewEngines as ViewEngineCollection:
          get:
            return _viewEngines
          set:
            _viewEngines = value
    |]
    
    return classDef