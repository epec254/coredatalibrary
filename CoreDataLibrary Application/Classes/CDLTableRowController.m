//
//  CDLTableRowController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import "CDLTableRowController.h"
#import "NSManagedObject+TypeOfProperty.h"

#import "CDLSingleLineTableRowController.h"
#import "CDLMultiLineTableRowController.h"
#import "CDLBooleanTableRowController.h"
#import "CDLRelationshipTableRowController.h"
#import "CDLTableSectionController.h"

@interface CDLTableRowController(PrivateMethods)

+ (NSDateFormatterStyle) dateFormatterStyleFromString:(NSString *)styleString;

- (void) _internalInitForDictionary:(NSDictionary *) rowInformation;

@end

@implementation CDLTableRowController


@synthesize rowLabel = _rowLabel;
@synthesize attributeKeyPath = _attributeKeyPath;
@synthesize rowType = _rowType;
@synthesize inAddMode = _inAddMode;
@synthesize editing = _editing;
//@synthesize delegate = _delegate;

@synthesize sectionController = _sectionController;

#pragma mark -
#pragma mark mem mgt

- (void)dealloc
{
	[_rowLabel release];
	_rowLabel = nil;
	
	[_attributeKeyPath release];
	_attributeKeyPath = nil;
	
	[super dealloc];
}


+ (id<CDLTableRowControllerProtocol>) tableRowControllerForDictionary:(NSDictionary *) rowInformation forSectionController:(CDLTableSectionController *) sectionController
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

	if ([newRowController respondsToSelector:@selector(setSectionController:)]) {
		newRowController.sectionController = sectionController;
	}
	
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
	} else if ([enumString isEqualToString:@"CDLTableRowTypeToManyRelationship"]) {
		return CDLTableRowTypeToManyRelationship;
	} else {
		[CDLUtilityMethods raiseExceptionWithName:@"Invalid rowType given" reason:[NSString stringWithFormat:@"Can't map given row type %@ to the CDLTableRowType enum", enumString]];
		return -1;
	}
}




#pragma mark -
#pragma mark init
- (id) initForDictionary:(NSDictionary *) rowInformation
{
	if (self = [super init]) {
		
		
		
		
	}
	
	return self;
}

- (void) _internalInitForDictionary:(NSDictionary *) rowInformation
{
	//Load the standard values for a rowController from the given dictionary.

	//rowLabel - NSString.  If not set, revert to nil.
	self.rowLabel = [rowInformation valueForKey:@"rowLabel"];
	
	if (![CDLUtilityMethods isLoadedStringValid:self.rowLabel]) {
		self.rowLabel = nil;
	}
	
	//attributeKeyPath - NSString
	self.attributeKeyPath = [rowInformation valueForKey:@"attributeKeyPath"];
	
	if (![CDLUtilityMethods isLoadedStringValid:self.attributeKeyPath]) {
		[CDLUtilityMethods raiseExceptionWithName:@"invalid input for CDLTableRowController" reason:@"attributeKeyPath can't be empty"];
	}
	
	//Will throw an exception if rowType is invalid.
	self.rowType = [CDLTableRowController cellTypeEnumFromString:[rowInformation valueForKey:@"rowType"]];
}



#pragma mark -
#pragma mark table view delegate methods - required
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSException *ex = [NSException exceptionWithName:@"Calling abstract method of CDLTableRowController" reason:NSLocalizedString(@"Create subclass.", @"Create subclass.") userInfo:nil];
	[ex raise];
	return nil;
}

//NO LONGER REQUIRED
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	NSException *ex = [NSException exceptionWithName:@"Calling abstract method of CDLTableRowController" reason:NSLocalizedString(@"Create subclass.", @"Create subclass.") userInfo:nil];
//	[ex raise];
//}


#pragma mark optional protocol methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	self.editing = editing;
}

#pragma mark -
#pragma mark property attributes  
			 
//default methods only work on string or number values
- (NSString *) attributeStringValue
{	
	return [CDLUtilityMethods stringValueForKeyPath:self.attributeKeyPath inObject:[self.sectionController managedObject]];
}

- (id) attributeObjectValue
{
	return [[self.sectionController managedObject] valueForKeyPath:self.attributeKeyPath];	
}



@end
