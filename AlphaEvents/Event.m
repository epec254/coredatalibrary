// 
//  Event.m
//  AlphaEvents
//
//  Created by Eric Peter on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Event.h"


@implementation Event 

@synthesize changedSection = _changedSection;


@dynamic name;
@dynamic timeStamp;
@dynamic nameFirstLetter;


- (void)setName:(NSString *)value 
{
    if (![value isEqualToString:self.name]) {
		self.changedSection = YES;
	}
	
	[self willChangeValueForKey:@"name"];
    [self setPrimitiveName:value];
    [self didChangeValueForKey:@"name"];
}

- (NSString *)nameFirstLetter 
{
    NSString *tmpValue = nil;
    
    [self willAccessValueForKey:@"nameFirstLetter"];
	
	if ([self.name length] > 0) {
		tmpValue = [[[self name] substringToIndex:1] uppercaseString];
		if ([[NSScanner scannerWithString:tmpValue] scanInt:NULL]) { //return # if its a number
			tmpValue = @"#";
		}
	} else { //sanity in case the attribute is not set.
		tmpValue = @"";
	}
    
    [self didAccessValueForKey:@"nameFirstLetter"];
    
    return tmpValue;
}

@end
