//
//  EventToVIP.h
//  ToManyEvents
//
//  Created by Eric Peter on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Event;
@class VIP;

@interface EventToVIP :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) VIP * vip;
@property (nonatomic, retain) Event * event;

@end



