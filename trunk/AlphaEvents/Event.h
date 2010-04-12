//
//  Event.h
//  AlphaEvents
//
//  Created by Eric Peter on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CDLSectionBugFixProtocol.h"


@interface Event :  NSManagedObject  <CDLSectionBugFixProtocol>
{
	@private
	BOOL _changedSection;
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * nameFirstLetter;


@end


@interface Event (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;

@end
