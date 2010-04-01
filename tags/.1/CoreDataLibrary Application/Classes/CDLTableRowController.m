//
//  ManagedObjectEditorRowController.m
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLTableRowController.h"
#import "NSManagedObject+TypeOfProperty.h"

#import "CDLSingleLineTableRowController.h"
#import "CDLMultiLineTableRowController.h"
#import "CDLBooleanTableRowController.h"
#import "CDLRelationshipTableRowController.h"

@interface CDLTableRowController(PrivateMethods)

+ (NSDateFormatterStyle) dateFormatterStyleFromString:(NSString *)styleString;
//@property (nonatomic, readonly) BOOL isNumberProperty; //Does the attributeKeyPath represent a NSNumber
- (void) booleanSwitchChanged:(id) sender;

- (NSString *) stringValueForKeyPath:(NSString *) keyPath inObject:(id) object;

@end

@implementation CDLTableRowController

@synthesize dateFormatterStyle = _dateFormatterStyle;
@synthesize timeFormatterStyle = _timeFormatterStyle;
@synthesize dateFormatter = _dateFormatter;
@synthesize rowLabel = _rowLabel;
@synthesize attributeKeyPath = _attributeKeyPath;
@synthesize rowType = _rowType;
@synthesize inAddMode = _inAddMode;

@synthesize delegate = _delegate;


//TODO: make init methods take delegate
+ (id<CDLTableRowControllerProtocol>) tableRowControllerForDictionary:(NSDictionary *) rowInformation forDelegate:(id<CDLTableRowControllerDelegate>) delegate
{
	id<CDLTableRowControllerProtocol> newRowController = nil;
	
	CDLTableRowType rowType = [CDLTableRowController cellTypeEnumFromString:[rowInformation valueForKey:@"rowType"]];
	NSString *customClassName = [rowInformation valueForKey:@"rowCustomControllerClass"];
	
	switch (rowType) {
		case CDLTableRowTypeSingleLineValueNoLabel:
		case CDLTableRowTypeSingleLineValueLargeLabel:
		case CDLTableRowTypeSingleLineValueSmallLabel:
			newRowController = [[[CDLSingleLineTableRowController alloc] initForDictionary:rowInformation] autorelease];
			break;
		case CDLTableRowTypeMultiLineValueNoLabel:
		case CDLTableRowTypeMultiLineValueSmallLabel:
			newRowController = [[[CDLMultiLineTableRowController alloc] initForDictionary:rowInformation] autorelease];
			break;
		case CDLTableRowTypeBooleanSwitch:
			newRowController = [[[CDLBooleanTableRowController alloc] initForDictionary:rowInformation] autorelease];
			break;
		case CDLTableRowTypeRelationship:
			newRowController = [[[CDLRelationshipTableRowController alloc] initForDictionary:rowInformation] autorelease];
			break;
		case CDLTableRowTypeCustom:
		{
			Class customControllerClass = NSClassFromString(customClassName);
			newRowController = [[[customControllerClass alloc] initForDictionary:rowInformation] autorelease];
		}
			break;

		default:
			break;
	}
	newRowController.delegate = delegate;
	return newRowController;
}

#pragma mark -
#pragma mark string to enum converters



+ (CDLTableRowType) cellTypeEnumFromString:(NSString *) enumString
{
	if ([enumString isEqualToString:@"CDLTableRowTypeSingleLineValueNoLabel"]) {
		return CDLTableRowTypeSingleLineValueNoLabel;
	} else if ([enumString isEqualToString:@"CDLTableRowTypeSingleLineValueLargeLabel"]) {
		return CDLTableRowTypeSingleLineValueLargeLabel;
	} else if ([enumString isEqualToString:@"CDLTableRowTypeSingleLineValueSmallLabel"]) {
		return CDLTableRowTypeSingleLineValueSmallLabel;
	} else if ([enumString isEqualToString:@"CDLTableRowTypeMultiLineValueNoLabel"]) {
		return CDLTableRowTypeMultiLineValueNoLabel;
	} else if ([enumString isEqualToString:@"CDLTableRowTypeMultiLineValueSmallLabel"]) {
		return CDLTableRowTypeMultiLineValueSmallLabel;
	} else if ([enumString isEqualToString:@"CDLTableRowTypeBooleanSwitch"]) {
		return CDLTableRowTypeBooleanSwitch;
	} else if ([enumString isEqualToString:@"CDLTableRowTypeRelationship"]) {
		return CDLTableRowTypeRelationship;
	} else if ([enumString isEqualToString:@"CDLTableRowTypeCustom"]) {
		return CDLTableRowTypeCustom;
	} else if ([enumString isEqualToString:@"CDLTableRowTypeToManyOrderedRelationship"]) {
		return CDLTableRowTypeToManyOrderedRelationship;
	} else {
		NSException *ex = [NSException exceptionWithName:@"Invalid string for rowType enum" reason:NSLocalizedString(@"Invalid string for enum - rowType", @"Invalid string for enum - selectionType") userInfo:nil];
		[ex raise];
		return -1;
	}
}

+ (NSDateFormatterStyle) dateFormatterStyleFromString:(NSString *)styleString
{
	if ([styleString isEqualToString:@"NSDateFormatterNoStyle"]) {
		return NSDateFormatterNoStyle;
	} else if ([styleString isEqualToString:@"NSDateFormatterShortStyle"]) {
		return NSDateFormatterShortStyle;
	} else if ([styleString isEqualToString:@"NSDateFormatterMediumStyle"]) {
		return NSDateFormatterMediumStyle;
	} else if ([styleString isEqualToString:@"NSDateFormatterLongStyle"]) {
		return NSDateFormatterLongStyle;
	} else if ([styleString isEqualToString:@"NSDateFormatterFullStyle"]) {
		return NSDateFormatterFullStyle;
	} else {
		return NSDateFormatterNoStyle; //default
	}
}


#pragma mark -
#pragma mark init
- (id) initForDictionary:(NSDictionary *) rowInformation
{
	if (self = [super init]) {
		//Load the standard values for a rowController from the given dictionary.
		
		self.rowLabel = [rowInformation valueForKey:@"rowLabel"];
		self.attributeKeyPath = [rowInformation valueForKey:@"attributeKeyPath"];
		
		//Attribute keyPath is required
		if (self.attributeKeyPath == nil) {
			NSException *ex = [NSException exceptionWithName:@"Row Information not valid" reason:NSLocalizedString(@"You must provide the attributeKeyPath", @"You must provide the attributeKeyPath") userInfo:nil];
			[ex raise];
		}
		
		//Will throw an exception if rowType is invalid.
		self.rowType = [CDLTableRowController cellTypeEnumFromString:[rowInformation valueForKey:@"rowType"]];
		
		//Create date/time formatter information - default is NSDateFormatterNoStyle for both.
		self.timeFormatterStyle = [CDLTableRowController dateFormatterStyleFromString:[rowInformation valueForKey:@"timeFormatterStyle"]];
		self.dateFormatterStyle = [CDLTableRowController dateFormatterStyleFromString:[rowInformation valueForKey:@"dateFormatterStyle"]];
		
		//Will be created on-demand if needed
		self.dateFormatter = nil;
	}
	
	return self;
}



#pragma mark -
#pragma mark table view delegate methods - required
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSException *ex = [NSException exceptionWithName:@"Calling abstract method of MOTableRowController" reason:NSLocalizedString(@"Create subclass.", @"Create subclass.") userInfo:nil];
	[ex raise];
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSException *ex = [NSException exceptionWithName:@"Calling abstract method of MOTableRowController" reason:NSLocalizedString(@"Create subclass.", @"Create subclass.") userInfo:nil];
	[ex raise];
}


#pragma mark optional protocol methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	_editing = editing;
}

#pragma mark -
#pragma mark property attributes  


//- (BOOL) isNumberProperty
//{	
//	NSString *attributeKey = [[self.attributeKeyPath componentsSeparatedByString:@"."] objectAtIndex:0]; //if the keyPath is x.y, just get X
//	
////	objc_property_t relationshipProperty = class_getProperty([self.delegate classOfManagedObject], [attributeKey cStringUsingEncoding:[NSString defaultCStringEncoding]]);
////	
////	NSString *relationshipAttributes = [NSString stringWithUTF8String: property_getAttributes(relationshipProperty)];
////	return [relationshipAttributes rangeOfString:@"NSNumber"].location != NSNotFound;
//	
//	
//	return [[[self.delegate managedObject] classOfKey:attributeKey] rangeOfString:@"NSNumber"].location != NSNotFound;
//}
			 

- (NSString *) attributeStringValue
{	
	return [self stringValueForKeyPath:self.attributeKeyPath inObject:[self.delegate managedObject]];
}

- (id) attributeObjectValue
{
	return [[self.delegate managedObject] valueForKeyPath:self.attributeKeyPath];	
}

- (NSString *) stringValueForKeyPath:(NSString *) keyPath inObject:(id) object
{
	id theValue = [object valueForKeyPath:keyPath];
	
	if (theValue == nil) { //property not set?  return empty string
		return @"";
	} else if ([theValue isKindOfClass:[NSString class]]) {
		return (NSString *) theValue;
	} else if ([theValue isKindOfClass:[NSDate class]]) {
		
		if (self.timeFormatterStyle == NSDateFormatterNoStyle && self.dateFormatterStyle == NSDateFormatterNoStyle) {
			NSException *ex = [NSException exceptionWithName:@"Attributes of NSDate must have a date OR time formatter style set." reason:NSLocalizedString(@"No date/time formatter style", @"No date/time formatter style") userInfo:nil];
			[ex raise];
		}
		
		if (self.dateFormatter == nil) {
			NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
			[newFormatter setTimeStyle:self.timeFormatterStyle];
			[newFormatter setDateStyle:self.dateFormatterStyle];
			
			self.dateFormatter = newFormatter;
			[newFormatter release];
		}
		
		return [self.dateFormatter stringFromDate:theValue];
		
	} else if ([theValue isKindOfClass:[NSNumber class]]) {
		return [theValue stringValue];
	} else {
		return [theValue description];
	}
}

#pragma mark -
#pragma mark mem mgt

- (void)dealloc
{
	[_rowLabel release];
	_rowLabel = nil;
	[_attributeKeyPath release];
	_attributeKeyPath = nil;





	[_dateFormatter release];
	_dateFormatter = nil;

	[super dealloc];
}

@end
