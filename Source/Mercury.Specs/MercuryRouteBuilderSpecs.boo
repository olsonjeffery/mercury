namespace Mercury.Specs

import System
import Machine.Specifications

public class MercuryRouteBuilderSpecs:
  context as Establish = def():
    pass

public class when_parsing_dependencies_from_a_route_action_whose_method_body_contains_a_single_dependency_on_string(MercuryRouteBuilderSpecs):
  context as Establish = def():
    pass
  
  should_find_a_single_dependency  as It
  should_find_a_dependency_of_type_string as It

