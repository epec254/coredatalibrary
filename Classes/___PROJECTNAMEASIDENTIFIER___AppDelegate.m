//
//  ___PROJECTNAMEASIDENTIFIER___AppDelegate.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "___PROJECTNAMEASIDENTIFIER___AppDelegate.h"
#import "DataController.h"
#import "CDLRootViewController.h"


@implementation ___PROJECTNAMEASIDENTIFIER___AppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	CDLRootViewController *rootViewController = [[CDLRootViewController alloc] initForListViewControllerStructure: [[NSBundle mainBundle] pathForResource:@"___PROJECTNAMEASIDENTIFIER___RootView" ofType:@"plist"]];
	
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

