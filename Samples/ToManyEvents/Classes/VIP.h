//
//  VIP.h
//  ToManyEvents
//
//  Created by Eric Peter on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class EventToVIP;

@interface VIP :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* eventVIPs;

@end


@interface VIP (CoreDataGeneratedAccessors)
- (void)addEventVIPsObject:(EventToVIP *)value;
- (void)removeEventVIPsObject:(EventToVIP *)value;
- (void)addEventVIPs:(NSSet *)value;
- (void)removeEventVIPs:(NSSet *)value;

@end

