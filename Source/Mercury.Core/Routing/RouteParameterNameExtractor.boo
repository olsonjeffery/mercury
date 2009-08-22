namespace Mercury.Core

import System
import System.Collections.Generic
import System.Text.RegularExpressions
import System.Linq.Enumerable from System.Core

public class RouteParameterNameExtractor:
  
  public def constructor():
    pass
  
  
  _getParams as Regex = Regex("\\{[^\\}]+\\}")
  _pattern as Regex = @/[^_a-zA-Z0-9]/
  public virtual def GetParametersFrom(route as string) as string*:
    matches = _getParams.Matches(route)
    params = (i.Value.Replace("{", string.Empty).Replace("}", string.Empty) for i as Match in matches).ToList()
    
    params = StripOutAnythingThatIsntAValidIdentifierCharacter(params)
    
    leftBracketCount = NumberOfTimesCharacterOccursInString("{", route)
    rightBracketCount = NumberOfTimesCharacterOccursInString("}", route)
    if not rightBracketCount == leftBracketCount and rightBracketCount == params.Count:
      raise InvalidOperationException("Malformed parameters in route '"+route+"'")
    
    return params
  
  public virtual def StripOutAnythingThatIsntAValidIdentifierCharacter(params as string*) as string*:
    return (_pattern.Replace(i, string.Empty) for i in params).ToList()
  
  public virtual def NumberOfTimesCharacterOccursInString(testValue as string, targetString as string) as int:
    ctr = 0
    for i as char in targetString:
      ctr++ if i.ToString().Equals(testValue)
    return ctr