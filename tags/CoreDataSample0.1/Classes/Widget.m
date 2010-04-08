// 
//  Widget.m
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Widget.h"

@implementation Widget 

@dynamic detail;
@dynamic timeStamp;
@dynamic nameFirstLetter;
@dynamic releaseDate;
@dynamic name;
@dynamic type;
@dynamic manufacturingProcesses;
@dynamic isCurrentProduct;

//custom properties
@synthesize changedSection = _changedSection;

#pragma mark -
#pragma mark name setter
/**
 Custom name setter to fix Apple Bug in NSFetchedResultController
 */
- (void)setName:(NSString *)value 
{
    if (![value isEqualToString:self.name]) {
		self.changedSection = YES;
	}
	
	[self willChangeValueForKey:@"name"];
    [self setPrimitiveName:value];
    [self didChangeValueForKey:@"name"];
}


#pragma mark -
#pragma mark Name first letter

/**
 return the first letter of the name property for use as a sectionKey in the UITableView
 */
- (NSString *)nameFirstLetter 
{
    NSString *tmpValue = nil;
    
    [self willAccessValueForKey:@"nameFirstLetter"];
	
	if ([self.name length] > 0) {
		tmpValue = [[[self name] substringToIndex:1] uppercaseString];
		if ([[NSScanner scannerWithString:tmpValue] scanInt:NULL]) { //return # if its a number
			tmpValue = @"#";
		}
	} else {
		tmpValue = @"";
	}

    
    [self didAccessValueForKey:@"nameFirstLetter"];
    
    return tmpValue;
}



@end
