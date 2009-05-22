namespace Mercury.Specs

import System
import System.Collections.Generic
import Machine.Specifications
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

import Machine.Specifications.NUnitShouldExtensionMethods from Machine.Specifications.NUnit

import System.Linq.Enumerable from System.Core

import Mercury.Core

public class when_splitting_a_path_and_the_view_is_nested_in_two_folders(AspNetMvcPathSplitKludgeSpecs):
  of_ as Because = def():
    result = pathKludge.SplitPath(fullViewName, false, "")
    controller = result[0]
    view = result[1]
  
  should_have_the_name_of_the_first_nested_folder_as_the_name_of_the_controller as It = def():
    controller.ShouldEqual("Controller")
  
  should_have_the_name_of_the_second_folder_and_the_view_as_the_view as It = def():
    view.ShouldEqual("Nested/View")
  
  fullViewName = "Controller/Nested/View"

public class when_splitting_a_path_and_the_view_is_nested_in_one_folder(AspNetMvcPathSplitKludgeSpecs):
  of_ as Because = def():
    result = pathKludge.SplitPath(fullViewName, false, "")
    controller = result[0]
    view = result[1]
  
  should_have_the_name_of_the_nested_folder_as_the_name_of_the_controller as It = def():
    controller.ShouldEqual("Controller")
  
  should_have_the_name_of_the_view_as_the_view as It = def():
    view.ShouldEqual("View")
  
  fullViewName = "Controller/View"

public class when_splitting_a_path_and_the_view_is_in_the_root_directory(AspNetMvcPathSplitKludgeSpecs):
  of_ as Because = def():
    result = pathKludge.SplitPath(fullViewName, false, "")
    controller = result[0]
    view = result[1]
  
  should_have_an_empty_controller as It = def():
    controller.ShouldEqual(string.Empty)
  
  should_have_the_view_name_as_the_view as It = def():
    view.ShouldEqual(fullViewName)
  
  fullViewName = "View"

public class when_checking_a_path_that_contains_a_file_extension_that_should_be_removed(AspNetMvcPathSplitKludgeSpecs):
  of_ as Because = def():
    result = pathKludge.SplitPath(fullViewName, true, ".spark")
    controller = result[0]
    view = result[1]
  
  should_strip_the_file_extension_from_the_view_name as It = def():
    view.ShouldEqual("View")
  
  fullViewName = "View.spark"

public class when_checking_a_path_that_contains_a_file_extension_that_should_not_be_removed(AspNetMvcPathSplitKludgeSpecs):
  of_ as Because = def():
    result = pathKludge.SplitPath(fullViewName, false, ".brail")
    controller = result[0]
    view = result[1]
  
  should_not_strip_the_file_extension_from_the_view_name as It = def():
    view.ShouldEqual("View.brail")
  
  fullViewName = "View.brail"

public class AspNetMvcPathSplitKludgeSpecs:
  context as Establish = def():
    pathKludge = AspNetMvcPathSplitKludge()
  
  protected pathKludge as AspNetMvcPathSplitKludge
  protected controller = null
  protected view = null

