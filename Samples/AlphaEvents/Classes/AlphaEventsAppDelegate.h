//
//  AlphaEventsAppDelegate.h
//  AlphaEvents
//
//  Created by Eric Peter on 4/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

@interface AlphaEventsAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
    UINavigationController *navigationController;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

