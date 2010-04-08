//
//  CoreDataSampleFor436AppDelegate.m
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "CoreDataSampleFor436AppDelegate.h"
#import "DataController.h"
#import "DemoViewController.h"
#import "Widget.h"
#import "WidgetType.h"
#import "WidgetToManufacturingProcess.h"
#import "ManufacturingProcess.h"
#import "ManufacturingProcessType.h"


@implementation CoreDataSampleFor436AppDelegate

@synthesize window;
@synthesize navigationController = _navigationController;

- (void) createData
{
	WidgetType *type1 = (WidgetType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetType"];
	type1.name = @"Type 1";
	type1.details = @"Some details blah blah";
	
	WidgetType *type2 = (WidgetType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetType"];
	type2.name = @"Type 2";
	type2.details = @"Some details blah blah";
	
	WidgetType *type3 = (WidgetType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetType"];
	type3.name = @"Type 3";
	type3.details = @"Some details blah blah";
	
	WidgetType *type4 = (WidgetType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetType"];
	type4.name = @"Type 4";
	type4.details = @"Some details blah blah";
	
	WidgetType *type5 = (WidgetType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetType"];
	type5.name = @"Type 5";
	type5.details = @"Some details blah blah";
	
	
	
	
	ManufacturingProcessType *procType1 = (ManufacturingProcessType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"ManufacturingProcessType"];
	procType1.name = @"Proc. Type 1";
	ManufacturingProcessType *procType2 = (ManufacturingProcessType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"ManufacturingProcessType"];
	procType2.name = @"Proc. Type 2";
	ManufacturingProcessType *procType3 = (ManufacturingProcessType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"ManufacturingProcessType"];
	procType3.name = @"Proc. Type 3";
	
	ManufacturingProcess *proc1 = (ManufacturingProcess *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"ManufacturingProcess"];
	proc1.name = @"Process Super";
	proc1.type = procType1;
	
	ManufacturingProcess *proc2 = (ManufacturingProcess *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"ManufacturingProcess"];
	proc2.name = @"Process Great";
	proc2.type = procType2;
	
	ManufacturingProcess *proc3 = (ManufacturingProcess *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"ManufacturingProcess"];
	proc3.name = @"Process Awesome";
	proc3.type = procType3;
	
	WidgetToManufacturingProcess *widgetProc1 = (WidgetToManufacturingProcess *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetToManufacturingProcess"];
	widgetProc1.order = [NSNumber numberWithInt:0];
	widgetProc1.manufacturingProcess = proc1;
	
	WidgetToManufacturingProcess *widgetProc2 = (WidgetToManufacturingProcess *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetToManufacturingProcess"];
	widgetProc2.order = [NSNumber numberWithInt:1];
	widgetProc2.manufacturingProcess = proc2;
	
	WidgetToManufacturingProcess *widgetProc3 = (WidgetToManufacturingProcess *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetToManufacturingProcess"];
	widgetProc3.order = [NSNumber numberWithInt:2];
	widgetProc3.manufacturingProcess = proc3;
	
	Widget *new = (Widget *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"Widget"];
	new.name = @"B New test";
	new.detail = @"dfdsfsdfdsfdsf";
	new.timeStamp = [NSDate date];
	new.releaseDate = [NSDate date];
	new.isCurrentProduct = [NSNumber numberWithBool:YES];
	new.type = type1;
	[new addManufacturingProcessesObject:widgetProc1];
	[new addManufacturingProcessesObject:widgetProc2];
	[new addManufacturingProcessesObject:widgetProc3];
	
	
	widgetProc1 = (WidgetToManufacturingProcess *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetToManufacturingProcess"];
	widgetProc1.order = [NSNumber numberWithInt:2];
	widgetProc1.manufacturingProcess = proc1;
	
	widgetProc2 = (WidgetToManufacturingProcess *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetToManufacturingProcess"];
	widgetProc2.order = [NSNumber numberWithInt:1];
	widgetProc2.manufacturingProcess = proc2;
	
	widgetProc3 = (WidgetToManufacturingProcess *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetToManufacturingProcess"];
	widgetProc3.order = [NSNumber numberWithInt:0];
	widgetProc3.manufacturingProcess = proc3;
	//	
	new = (Widget *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"Widget"];
	new.name = @"C new test";
	new.detail = @"dfdsfsdfdsfdsf dfdsfsdfdsfdsf dfdsfsdfdsfdsf dfdsfsdfdsfdsf dfdsfsdfdsfdsf";
	new.timeStamp = [NSDate date];
	new.releaseDate = [NSDate date];
	new.isCurrentProduct = [NSNumber numberWithBool:YES];
	new.type = type2;
	[new addManufacturingProcessesObject:widgetProc1];
	[new addManufacturingProcessesObject:widgetProc2];
	[new addManufacturingProcessesObject:widgetProc3];
	
	
	widgetProc1 = (WidgetToManufacturingProcess *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetToManufacturingProcess"];
	widgetProc1.order = [NSNumber numberWithInt:2];
	widgetProc1.manufacturingProcess = proc1;
	
	widgetProc2 = (WidgetToManufacturingProcess *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetToManufacturingProcess"];
	widgetProc2.order = [NSNumber numberWithInt:1];
	widgetProc2.manufacturingProcess = proc2;
	
	widgetProc3 = (WidgetToManufacturingProcess *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetToManufacturingProcess"];
	widgetProc3.order = [NSNumber numberWithInt:0];
	widgetProc3.manufacturingProcess = proc3;
	
	new = (Widget *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"Widget"];
	new.name = @"a new test";
	new.detail = @"Some very long detailed description about something dsfkdasjf ads;klfjads;lfjads;kfjiurfj";
	new.timeStamp = [NSDate date];
	new.releaseDate = [NSDate date];
	new.isCurrentProduct = [NSNumber numberWithBool:NO];
	[new addManufacturingProcessesObject:widgetProc1];
	[new addManufacturingProcessesObject:widgetProc2];
	[new addManufacturingProcessesObject:widgetProc3];
	

	
	[[DataController sharedDataController] saveFromSource:@"test"];	
}

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	//[self createData];
	
    DemoViewController *demoViewController = [[DemoViewController alloc] init];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:demoViewController];
	self.navigationController = navController;
	[navController release];
	[demoViewController release];
		
	[window addSubview:[navController view]];
    [window makeKeyAndVisible];
	

	
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
  	if ([[[DataController sharedDataController] managedObjectContext] hasChanges]) {
		[[DataController sharedDataController] saveFromSource:@"application will terminate"];
	} 
}




#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[window release];
	[_navigationController release];
	[super dealloc];
}


@end

