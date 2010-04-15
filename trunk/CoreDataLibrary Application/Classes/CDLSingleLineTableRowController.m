//
//  CDLSingleLineTableRowController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary


#import "CDLSingleLineTableRowController.h"
#import "CDLAbstractFieldEditController.h"
#import "CDLTextFieldEditController.h"
#import "CDLDateFieldEditController.h"

#import "NSManagedObject+TypeOfProperty.h"

#import "CDLTableSectionController.h"

@interface CDLSingleLineTableRowController(PrivateMethods)
+ (NSDateFormatterStyle) dateFormatterStyleFromString:(NSString *)styleString;
@end

@implementation CDLSingleLineTableRowController

@synthesize dateFormatterStyle = _dateFormatterStyle;
@synthesize timeFormatterStyle = _timeFormatterStyle;
@synthesize dateFormatter = _dateFormatter;


- (void)dealloc
{
	[_dateFormatter release];
	_dateFormatter = nil;
	
	[super dealloc];
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


- (id) initForDictionary:(NSDictionary *) rowInformation
{
	if (self = [super initForDictionary:rowInformation]) {

		[self _internalInitForDictionary:rowInformation];
		//input validation errors
		NSMutableArray *inputValidationErrors = [[NSMutableArray alloc] init];
		
		if ([[self.attributeKeyPath componentsSeparatedByString:@"."] count] > 1) {
			//we only handle keys not keyPaths in this type of controller
			[inputValidationErrors addObject:[NSString stringWithFormat:@"SingleLineTableRow Controller does not handle keyPaths, please provide a key (You provided %@)", self.attributeKeyPath]];
		}
		
		NSString *classOfKey = [[self.sectionController managedObject] classOfKey:self.attributeKeyPath];
		
		if ([classOfKey isEqualToString:@"NSString"] || [classOfKey isEqualToString:@"NSNumber"] || [classOfKey isEqualToString:@"NSDate"]) {
			
			[inputValidationErrors addObject:[NSString stringWithFormat:@"SingleLineTableRow Controller only handles NSStrings, NSNumbers and NSDates (You provided a %@)", classOfKey]];
		}
		
		//Create date/time formatter information - default is NSDateFormatterNoStyle for both.
		self.timeFormatterStyle = [CDLSingleLineTableRowController dateFormatterStyleFromString:[rowInformation valueForKey:@"timeFormatterStyle"]];
		self.dateFormatterStyle = [CDLSingleLineTableRowController dateFormatterStyleFromString:[rowInformation valueForKey:@"dateFormatterStyle"]];
		
		//Will be created on-demand if needed
		_dateFormatter = nil;
		
		if ([inputValidationErrors count] > 0) {
			[CDLUtilityMethods raiseExceptionWithName:@"Invalid input for SingleLineTableRowController" reason:[inputValidationErrors description]];
		}
		
		[inputValidationErrors release];
	}
	return self;
}

- (NSDateFormatter *) dateFormatter{
	if (_dateFormatter != nil) {
		return _dateFormatter;
	}
	
	//only return a dateFormatter if we have the style set properply.
	if (!(self.timeFormatterStyle == NSDateFormatterNoStyle && self.dateFormatterStyle == NSDateFormatterNoStyle)) {
		_dateFormatter = [[NSDateFormatter alloc] init];
		[_dateFormatter setDateStyle:self.dateFormatterStyle];
		[_dateFormatter setTimeStyle:self.timeFormatterStyle];
	} else {
		_dateFormatter = nil;
	}
	
	return _dateFormatter;
}


- (NSString *) attributeStringValue
{
	return [CDLUtilityMethods stringValueForKeyPath:self.attributeKeyPath inObject:[self.sectionController managedObject] withDateFormatter:self.dateFormatter];
}

#pragma mark -
#pragma mark table view delegate methods - required

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellTypeSingleLineNoLabel = @"CellTypeSingleLineNoLabelCell";
	static NSString *CellTypeSingleLineLargeLabelInCell = @"CellTypeSingleLineLabelInCellLargeCell";
	static NSString *CellTypeSingleLineSmallLabelInCell = @"CellTypeSingleLineLabelInCellSmallCell";
	
	UITableViewCell *cell = nil;
	UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
	NSString *cellIdentifier = nil;
	
	
	switch (self.rowType) {
		case CDLTableRowTypeSingleLineValueNoLabel:
			cellStyle = UITableViewCellStyleDefault;
			cellIdentifier = CellTypeSingleLineNoLabel;
			break;
		case CDLTableRowTypeSingleLineValueLargeLabel:
			cellStyle = UITableViewCellStyleValue1;
			cellIdentifier = CellTypeSingleLineLargeLabelInCell;
			break;
		case CDLTableRowTypeSingleLineValueSmallLabel:
			cellStyle = UITableViewCellStyleValue2;
			cellIdentifier = CellTypeSingleLineSmallLabelInCell;
			break;
		default:
			break;
	}
	
	//Create the cell/get from the cache
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
    }
	
	if (cellStyle == UITableViewCellStyleDefault) { //textLabel is the place we put the attribute
		cell.textLabel.text = self.attributeStringValue;
	} else { //textDetailLabel is where we put the attribute
		cell.detailTextLabel.text = self.attributeStringValue;
		cell.textLabel.text = self.rowLabel;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (tableView.editing) {
		CDLAbstractFieldEditController *fieldEditController = nil;
		
		//Determine the proper type of Edit Controller to push by looking at the class of the key
		NSString *classOfKey = [[self.sectionController managedObject] classOfKey:self.attributeKeyPath];
		if ([classOfKey isEqualToString:@"NSString"] || [classOfKey isEqualToString:@"NSNumber"]) {
			fieldEditController = [[CDLTextFieldEditController alloc] initForManagedObject:[self.sectionController managedObject] withLabel:self.rowLabel forKeyPath:self.attributeKeyPath];
		} else if ([classOfKey isEqualToString:@"NSDate"]) {
			
			fieldEditController = [[CDLDateFieldEditController alloc] initForManagedObject:[self.sectionController managedObject] withLabel:self.rowLabel forKeyPath:self.attributeKeyPath withDateFormatterStyle:self.dateFormatterStyle withTimeFormatterStyle:self.timeFormatterStyle];
		}
		
		[fieldEditController setInAddMode:self.inAddMode];
		fieldEditController.delegate = (id<CDLFieldEditControllerDelegate>) self.sectionController; //we know the delegate of this class will be a CDLTableSectionController which implements this protocol

		[self.sectionController pushViewController:fieldEditController animated:YES];
		[fieldEditController release];
		
	} else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	
}


@end
