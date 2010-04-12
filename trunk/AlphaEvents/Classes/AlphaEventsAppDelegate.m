//
//  AlphaEventsAppDelegate.m
//  AlphaEvents
//
//  Created by Eric Peter on 4/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AlphaEventsAppDelegate.h"
#import "DataController.h"
#import "CDLRootViewController.h"


@implementation AlphaEventsAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	CDLRootViewController *rootViewController = [[CDLRootViewController alloc] initForListViewControllerStructure: [[NSBundle mainBundle] pathForResource:@"AlphaEventsRootView" ofType:@"plist"]];
	
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

