namespace Mercury.Specs

import System
import System.Reflection
import Boo.Lang.Compiler
import Boo.Lang.Compiler.IO
import Boo.Lang.Compiler.Ast
import Boo.Lang.Compiler.Pipelines
import Mercury.Core
import Microsoft.Practices.ServiceLocation
import Machine.Specifications
import Rhino.Mocks
import System.Web.Mvc
import Boo.Lang.Builtins

public class CommonSpecBase:
  context as Establish = def():
    container = MockRepository.GenerateMock[of IServiceLocator]()
    viewEngines = MockRepository.GenerateMock[of ViewEngineCollection]()
    New = NewService()
  
  protected static def FieldIsOfType(type as string):
    return { x as Field | x.Type.Equals([| typeof($type) |].Type) }
  
  protected static def GenerateUnparsedDependencyOn(type as Type) as Block:
    return GenerateUnparsedDependencyOn(type, "specDep_"+random.Next().ToString())
  
  protected static def GenerateUnparsedDependencyOn(type as Type, name as string) as Block:
    depMacro = DependencyMacro()
    macro = MacroStatement()
    typeRef = [| typeof($type) |]
    macro.Arguments.Add(TryCastExpression(ReferenceExpression(name), typeRef.Type))
    return depMacro.Expand(macro)
  
  protected static def CompileCodeAndGetContext(code as string) as CompilerContext:
    booC = BooCompiler()
    booC.Parameters.Input.Add(StringInput("name",code))
    for i in AppDomain.CurrentDomain.GetAssemblies():
      booC.Parameters.AddAssembly(i)
    booC.Parameters.Pipeline = CompileToMemory()
    booC.Parameters.Ducky = false
    compileContext = booC.Run()
    raise join(e for e in compileContext.Errors, "\n") if compileContext.GeneratedAssembly is null
    return compileContext
    
  protected static def GetTypeFromAssemblyNamed(assembly as Assembly, typeName as string) as Type:
    return assembly.GetType(typeName, true, true)
  
  protected static def GetTypeFromAssemblyThatImplements(assembly as Assembly, targetType as Type) as Type:
    type as Type = null
    for i in assembly.GetTypes():
      isMatch = (true if targetType.IsAssignableFrom(i) else false)
      raise "Multiply types that implement "+targetType.ToString()+" have been found!" if type is not null and isMatch
      type = i if isMatch
    return type
    
  protected static def CompileCodeAndGetTypeNamed(code as string, typeName as string) as Type:
    compileContext = CompileCodeAndGetContext(code)
    return GetTypeFromAssemblyNamed(compileContext.GeneratedAssembly, typeName)
  
  protected static viewEngines as ViewEngineCollection
  protected static container as IServiceLocator
  protected static memberIsAConstructor = {member as TypeMember | member isa Constructor}
  protected static memberIsAField = { member as TypeMember | member  isa Field }
  protected static constructorHasMoreThanZeroParameters = { ctor as Constructor | ctor.Parameters.Count > 0}
  protected static random as Random = Random()
  
  public static New as NewService