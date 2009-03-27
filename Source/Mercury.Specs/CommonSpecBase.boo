namespace Mercury.Specs

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.IO
import Boo.Lang.Compiler.Ast
import Boo.Lang.Compiler.Pipelines
import Mercury.Core

public class CommonSpecBase:
  protected static memberIsAConstructor = {member as TypeMember | member isa Constructor}
  protected static memberIsAField = { member as TypeMember | member  isa Field }
  protected static constructorHasMoreThanZeroParameters = { ctor as Constructor | ctor.Parameters.Count > 0}
  protected static random as Random = Random()

  protected static def GenerateUnparsedDependencyOn(type as Type) as Block:
    return GenerateUnparsedDependencyOn(type, "specDep_"+random.Next().ToString())
  
  protected static def GenerateUnparsedDependencyOn(type as Type, name as string) as Block:
    depMacro = DependencyMacro()
    macro = MacroStatement()
    typeRef = [| typeof($type) |]
    macro.Arguments.Add(TryCastExpression(ReferenceExpression(name), typeRef.Type))
    return depMacro.Expand(macro)
  
  protected static def CompileCodeAndGetTypeNamed(code as string, typeName as string) as Type:
    booC = BooCompiler()
    booC.Parameters.Input.Add(StringInput("name",code))
    booC.Parameters.Pipeline = CompileToMemory()
    booC.Parameters.Ducky = false
    context = booC.Run()
    raise join(e for e in context.Errors, "\n") if context.GeneratedAssembly is null
    return context.GeneratedAssembly.GetType(typeName, true, true)