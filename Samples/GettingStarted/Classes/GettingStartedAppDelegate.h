//
//  GettingStartedAppDelegate.h
//  GettingStarted
//
//  Created by Eric Peter on 4/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

@interface GettingStartedAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
    UINavigationController *navigationController;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

