//
//  Event.h
//  GettingStarted
//
//  Created by Eric Peter on 4/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class EventType;

@interface Event :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * publicEvent;
@property (nonatomic, retain) EventType * type;

@end



