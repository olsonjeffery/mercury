namespace Mercury.Core

import System
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class PropertyAstBuilder:

  def constructor():
    pass
  
  public def SimpleGetterProperty(propertyNameString as string, encapsulatedFieldNameString as string, typeRef as TypeReference) as Property:
    encapsulatedFieldNameReference = ReferenceExpression(encapsulatedFieldNameString)
    property = Property(propertyNameString)
    property.Type = typeRef
    
    property.Getter = [|
      def get_property() as $(property.Type):
        return $encapsulatedFieldNameReference
    |]
    property.Getter.Name = "get_"+propertyNameString
    return property