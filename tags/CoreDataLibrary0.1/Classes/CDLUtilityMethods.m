//
//  CDLUtilityMethods.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the BSD License
//
//  code.google.com/p/coredatalibrary


#import "CDLUtilityMethods.h"


@implementation CDLUtilityMethods

+ (BOOL) isLoadedStringValid:(NSString *) loadedString
{
	if (loadedString == nil || ![loadedString isKindOfClass:[NSString class]] || [loadedString length] == 0) {
		return NO;
	} else {
		return YES;
	}
}

+ (BOOL) isLoadedArrayValid:(NSArray *)loadedArray
{
	if (loadedArray == nil || ![loadedArray isKindOfClass:[NSArray class]] || [loadedArray count] == 0) {
		return NO;
	} else {
		return YES;
	}
}

+ (BOOL) isLoadedDictionaryValid:(NSDictionary *)loadedDictionary
{
	if (loadedDictionary == nil || ![loadedDictionary isKindOfClass:[NSDictionary class]] || [loadedDictionary count] == 0) {
		return NO;
	} else {
		return YES;
	}	
}

+ (NSString *) stringValueForKeyPath:(NSString *) keyPath inObject:(id) object withDateFormatter:(NSDateFormatter *) dateFormatter
{
	id theValue = [object valueForKeyPath:keyPath];
	
	if (theValue == nil) { //property not set?  return empty string
		return @"";
	} else if ([theValue isKindOfClass:[NSString class]]) {
		return (NSString *) theValue;
	} else if ([theValue isKindOfClass:[NSDate class]]) {
		
		if (dateFormatter == nil) {
			NSException *ex = [NSException exceptionWithName:@"Attributes of NSDate must have a date OR time formatter style set." reason:@"No date/time formatter style" userInfo:nil];
			[ex raise];
		}
		
		return [dateFormatter stringFromDate:theValue];
	
		
	} else if ([theValue isKindOfClass:[NSNumber class]]) {
		return [theValue stringValue];
	} else {
		return [theValue description];
	}
}

+ (NSString *) stringValueForKeyPath:(NSString *) keyPath inObject:(id) object
{
	return [CDLUtilityMethods stringValueForKeyPath:keyPath inObject:object withDateFormatter:nil];
}

+ (void) raiseExceptionWithName:(NSString *) name reason:(NSString *) reason
{
	NSException *ex = [NSException exceptionWithName:name reason:reason userInfo:nil];
	[ex raise];
}


@end
