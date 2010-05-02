//
//  CDLTableRowController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the BSD License
//
//  code.google.com/p/coredatalibrary

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

//- (NSString *) stringValueForKeyPath:(NSString *) keyPath inObject:(id) object;

@end

@implementation CDLTableRowController


@synthesize rowLabel = _rowLabel;
@synthesize attributeKeyPath = _attributeKeyPath;
@synthesize rowType = _rowType;
@synthesize inAddMode = _inAddMode;

@synthesize delegate = _delegate;

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
	
	return self;
}



#pragma mark -
#pragma mark table view delegate methods - required
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSException *ex = [NSException exceptionWithName:@"Calling abstract method of CDLTableRowController" reason:NSLocalizedString(@"Create subclass.", @"Create subclass.") userInfo:nil];
	[ex raise];
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSException *ex = [NSException exceptionWithName:@"Calling abstract method of CDLTableRowController" reason:NSLocalizedString(@"Create subclass.", @"Create subclass.") userInfo:nil];
	[ex raise];
}


#pragma mark optional protocol methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	_editing = editing;
}

#pragma mark -
#pragma mark property attributes  
			 
//default methods only work on string or number values
- (NSString *) attributeStringValue
{	
	return [CDLUtilityMethods stringValueForKeyPath:self.attributeKeyPath inObject:[self.delegate managedObject]];
}

- (id) attributeObjectValue
{
	return [[self.delegate managedObject] valueForKeyPath:self.attributeKeyPath];	
}



@end
