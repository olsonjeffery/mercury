namespace Mercury.Core

import System
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import System.Linq.Enumerable from System.Core

public class DependencyAstBuilder:

  public def constructor():
    pass
  
  public def GetDependenciesForClass(body as Block, module as Module) as ParameterDeclaration*:
    inActionDependencies = PullDependenciesFromMacroBody(body)
    moduleLevelDependencies = PullDependenciesFromModule(module)
    
    return MergeDependencyLists(inActionDependencies, moduleLevelDependencies)
    
  public def PullDependenciesFromMacroBody(body as Block) as ParameterDeclaration*:
    list = List of ParameterDeclaration()
    newBody = StatementCollection()
    for i in body.Statements:
      if i["dependency"]  == true:
        for j as DeclarationStatement in (i as Block).Statements:
          list.Add(ParameterDeclaration(j.Declaration.Name, j.Declaration.Type))
      else:
        newBody.Add(i)
    body.Statements = newBody
    raise DuplicateDependencyException() if not VerifyNoOverlappingDependencyNames(list)
    return list
  
  public def PullDependenciesFromModule(module as Module) as ParameterDeclaration*:
    list = List of ParameterDeclaration()
    return list
    
  public def MergeDependencyLists(inAction as ParameterDeclaration*, moduleLevel as ParameterDeclaration*) as ParameterDeclaration*:
    list = List of ParameterDeclaration()
    for i in inAction:
      list.Add(i)
    for i in moduleLevel:
      list.Add(i)
    raise DuplicateDependencyException() if not VerifyNoOverlappingDependencyNames(list)
    return list
  
  public def VerifyNoOverlappingDependencyNames(deps as ParameterDeclaration*) as bool:
    tempDict = Dictionary[of string, ParameterDeclaration]()
    for i in deps:
      return false if tempDict.ContainsKey(i.Name)
      tempDict[i.Name] = i
    return true