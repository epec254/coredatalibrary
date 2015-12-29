//
//  ToManyEventsAppDelegate.h
//  ToManyEvents
//
//  Created by Eric Peter on 4/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

@interface ToManyEventsAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
    UINavigationController *navigationController;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

