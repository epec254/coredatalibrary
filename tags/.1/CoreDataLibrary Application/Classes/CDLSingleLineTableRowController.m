//
//  MOSingleLineTableRowController.m
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLSingleLineTableRowController.h"
#import "CDLAbstractFieldEditController.h"
#import "CDLTextFieldEditController.h"
#import "CDLDateFieldEditController.h"

#import "NSManagedObject+TypeOfProperty.h"


@implementation CDLSingleLineTableRowController

- (id) initForDictionary:(NSDictionary *) rowInformation
{
	if (self = [super initForDictionary:rowInformation]) {
		
		BOOL isValid = YES;
		NSString *error = @"Error(s): ";
		
		if ([[self.attributeKeyPath componentsSeparatedByString:@"."] count] > 1) {
			//we only handle keys not keyPaths in this type of controller
			error = [error stringByAppendingFormat:@"SingleLineTableRow Controller does not handle keyPaths, please provide a key (You provided %@)", self.attributeKeyPath];
			isValid = NO;
		}
		
		NSString *classOfKey = [[self.delegate managedObject] classOfKey:self.attributeKeyPath];
		
		if ([classOfKey isEqualToString:@"NSString"] || [classOfKey isEqualToString:@"NSNumber"] || [classOfKey isEqualToString:@"NSDate"]) {
			error = [error stringByAppendingFormat:@"SingleLineTableRow Controller only handles NSStrings, NSNumbers and NSDates (You provided a %@)", classOfKey];
			isValid = NO;
		}
		
		if (!isValid) {
			NSException *ex = [NSException exceptionWithName:@"Invalid input for SingleLineTableRowController" reason:error userInfo:nil];
			[ex raise];
		}
		
		
	}
	return self;
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
		NSString *classOfKey = [[self.delegate managedObject] classOfKey:self.attributeKeyPath];
		if ([classOfKey isEqualToString:@"NSString"] || [classOfKey isEqualToString:@"NSNumber"]) {
			fieldEditController = [[CDLTextFieldEditController alloc] initForManagedObject:[self.delegate managedObject] withLabel:self.rowLabel forKeyPath:self.attributeKeyPath];
		} else if ([classOfKey isEqualToString:@"NSDate"]) {
			
			fieldEditController = [[CDLDateFieldEditController alloc] initForManagedObject:[self.delegate managedObject] withLabel:self.rowLabel forKeyPath:self.attributeKeyPath withDateFormatterStyle:self.dateFormatterStyle withTimeFormatterStyle:self.timeFormatterStyle];
		}
		
		[fieldEditController setInAddMode:self.inAddMode];
		[self.delegate pushViewController:fieldEditController animated:YES];
		[fieldEditController release];
		
	} else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	
}

@end
