namespace Mercury.ExampleSite

import System

public class RouteInfo:
	public controller as string
	public action as string
	public id as string
	
	public def constructor(controllerTemp as string, actionTemp as string, idTemp as string):
		self.controller = controllerTemp;
		self.action = actionTemp;
		self.id = idTemp;