namespace Mercury.Specs

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
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
