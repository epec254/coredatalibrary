//
//  GettingStartedAppDelegate.m
//  GettingStarted
//
//  Created by Eric Peter on 4/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "GettingStartedAppDelegate.h"
#import "DataController.h"
#import "CDLRootViewController.h"
#import "EventType.h"

@implementation GettingStartedAppDelegate

@synthesize window;
@synthesize navigationController;

- (void) createEventTypes
{
	//create a few sample types
	
	EventType *aType = (EventType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"EventType"];
	aType.name = @"PR";
	
	aType = (EventType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"EventType"];
	aType.name = @"Fundraising";
	
	aType = (EventType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"EventType"];
	aType.name = @"TV Promotion";
	
	aType = (EventType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"EventType"];
	aType.name = @"Lecture";
	
	[[DataController sharedDataController] saveFromSource:@"Create sample data"];
}

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	// Uncomment to create sample event types.
	//[self createEventTypes];
	
	CDLRootViewController *rootViewController = [[CDLRootViewController alloc] initForListViewControllerStructure: [[NSBundle mainBundle] pathForResource:@"GettingStartedRootView" ofType:@"plist"]];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
	self.navigationController = navController;
	
	[navController release];
	[rootViewController release];
	
	[window addSubview:[self.navigationController view]];
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
	
    [navigationController release];
	[window release];
	[super dealloc];
}


@end

