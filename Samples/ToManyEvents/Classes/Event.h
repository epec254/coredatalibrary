//
//  Event.h
//  ToManyEvents
//
//  Created by Eric Peter on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class EventToVIP;

@interface Event :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSSet* vips;

@end


@interface Event (CoreDataGeneratedAccessors)
- (void)addVipsObject:(EventToVIP *)value;
- (void)removeVipsObject:(EventToVIP *)value;
- (void)addVips:(NSSet *)value;
- (void)removeVips:(NSSet *)value;

@end

