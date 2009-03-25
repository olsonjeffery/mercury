namespace Mercury.Core

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import System.Collections.Generic
import System.Linq.Enumerable from System.Core

public class ConstructorAndFieldAstBuilder:
  def constructor():
    pass

  public def PopulateConstructorWithParametersFromDependencies(ctor as Constructor, params as ParameterDeclaration*):
    for i in params:
      ctor.Parameters.Add(i)
    return ctor
  
  public def PopulateClassDefinitionWithFieldsFromDependencies(classDef as ClassDefinition, fields as ParameterDeclaration*):
    for i in fields:
      field = Field(i.Type, [| null |])
      field.Name = i.Name
      classDef.Members.Add(field)
    
    return classDef
  
  public def PopulateConstructorWithFieldAssignmentsFromMethodParameters(ctor as Constructor):
    ctor.Body = Block()
    for i in ctor.Parameters:
      refExp = ReferenceExpression(i.Name)
      assignment = [| self.$(i.Name) = $(refExp) |]
      ctor.Body.Add(assignment)
    
    return ctor
  
  public def PopulateClassDefinitionWithFieldsAndConstructorParamsFromDependencies(classDef as ClassDefinition, deps as ParameterDeclaration*) as ClassDefinition:
    return classDef if deps.Count() == 0
    ctor = Constructor()
    
    classDef = PopulateClassDefinitionWithFieldsFromDependencies(classDef, deps)
    ctor = PopulateConstructorWithParametersFromDependencies(ctor, deps)
    ctor = PopulateConstructorWithFieldAssignmentsFromMethodParameters(ctor)
    
    classDef.Members.Add(ctor)
    return classDef