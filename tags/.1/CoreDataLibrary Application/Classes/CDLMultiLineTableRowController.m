//
//  MOMultiLineTableRowController.m
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLMultiLineTableRowController.h"
#import "CDLMultiLineTextFieldEditController.h"

#import "NSManagedObject+TypeOfProperty.h"

@interface CDLMultiLineTableRowController(PrivateMethods)

// label/cell sizes for multiline strings
- (CGFloat) calculateLabelHeightForMultiLineString: (NSString *)text ofFont:(UIFont *)font;
- (CGFloat) calculateLabelHeightForMultiLineString: (NSString *)text; //use default system font
- (CGFloat) calculateCellHeightForMultiLineString: (NSString *)text ofFont:(UIFont *)font;
- (CGFloat) calculateCellHeightForMultiLineString: (NSString *)text; //use default system font

@end

@implementation CDLMultiLineTableRowController
- (id) initForDictionary:(NSDictionary *) rowInformation
{
	if (self = [super initForDictionary:rowInformation]) {
		
		BOOL isValid = YES;
		NSString *error = @"Error(s): ";
		
		if ([[self.attributeKeyPath componentsSeparatedByString:@"."] count] > 1) {
			//we only handle keys not keyPaths in this type of controller
			error = [error stringByAppendingFormat:@"MultiLineTableRow Controller does not handle keyPaths, please provide a key (You provided %@)", self.attributeKeyPath];
			isValid = NO;
		}
		
		NSString *classOfKey = [[self.delegate managedObject] classOfKey:self.attributeKeyPath];
		
		if ([classOfKey isEqualToString:@"NSString"]) {
			error = [error stringByAppendingFormat:@"MultiLineTableRow Controller only handles NSString (You provided a %@)", classOfKey];
			isValid = NO;
		}
		
		if (!isValid) {
			NSException *ex = [NSException exceptionWithName:@"Invalid input for MultiLineTableRowController" reason:error userInfo:nil];
			[ex raise];
		}
		
		
	}
	return self;
}
#pragma mark -
#pragma mark table view delegate methods - required

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellTypeMultiLineNoLabel = @"CellTypeMultiLineNoLabelCell";
	static NSString *CellTypeMultiLineLabelInCellSmall = @"CellTypeMultiLineLabelInCellSmallCell";
	
	UITableViewCell *cell = nil;
	UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
	NSString *cellIdentifier = nil;
	
	
	switch (self.rowType) {
		case CDLTableRowTypeMultiLineValueNoLabel:
			cellStyle = UITableViewCellStyleDefault;
			cellIdentifier = CellTypeMultiLineNoLabel;
			break;
		case CDLTableRowTypeMultiLineValueSmallLabel:
			cellStyle = UITableViewCellStyleValue2;
			cellIdentifier = CellTypeMultiLineLabelInCellSmall;
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
	
	//Multi Line Strings: make the label the proper size.
	if (self.rowType == CDLTableRowTypeMultiLineValueSmallLabel) {
		//make this cell's label expand if the string is bigger than a line
		CGRect newFrame = cell.detailTextLabel.frame;
		cell.detailTextLabel.frame = newFrame;
		cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
		cell.detailTextLabel.numberOfLines = 0;
	} else if (self.rowType == CDLTableRowTypeMultiLineValueNoLabel) {
		CGRect newFrame = cell.textLabel.frame;
		//		cell.textLabel.font =[UIFont boldSystemFontOfSize:[UIFont systemFontSize] + 2.0];
		cell.textLabel.frame = newFrame;
		cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		cell.textLabel.numberOfLines = 0;
	}
	
	
	//Place the attribute values/labels based on type of cell
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
	//Push edit controller
	if (tableView.editing) {
		CDLMultiLineTextFieldEditController *fieldEditController = [[CDLMultiLineTextFieldEditController alloc] initForManagedObject:[self.delegate managedObject] withLabel:self.rowLabel forKeyPath:self.attributeKeyPath];
		
		[fieldEditController setInAddMode:self.inAddMode];
		
		[self.delegate pushViewController:fieldEditController animated:YES];
		[fieldEditController release];
		
	}
	
}

#pragma mark optional protocol methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//only a multiline string cell can be the non default height
	//and only if the string content is bigger than a line
	CGFloat suggestedHeight = tableView.rowHeight;
	switch (self.rowType) {
		case CDLTableRowTypeMultiLineValueNoLabel:
			suggestedHeight = [self calculateCellHeightForMultiLineString:self.attributeStringValue ofFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize] + 2.0]]; //default font for this type of cell
			break;
		case CDLTableRowTypeMultiLineValueSmallLabel:
			suggestedHeight = [self calculateCellHeightForMultiLineString:self.attributeStringValue ofFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize] + 1.0]]; //default font for this type of cell
			break;
			
		default:
			break;
	}
	
	return ((suggestedHeight) > tableView.rowHeight) ? (suggestedHeight) : tableView.rowHeight;
}


#pragma mark -
#pragma mark row heights

- (CGFloat) calculateLabelHeightForMultiLineString: (NSString *)text
{
	return [self calculateLabelHeightForMultiLineString:text ofFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
}

- (CGFloat) calculateLabelHeightForMultiLineString: (NSString *)text ofFont:(UIFont *)font
{
	CGSize constrainedSize; 
	//account for edit accessory size
	float rowEditingAccessorySize = (_editing) ? 30.0f : 0.0f;
	switch (self.rowType) {
		case CDLTableRowTypeMultiLineValueSmallLabel:
			constrainedSize = CGSizeMake(210.0f - rowEditingAccessorySize, MAXFLOAT);
			break;
		case CDLTableRowTypeMultiLineValueNoLabel:
			constrainedSize = CGSizeMake(320.0f - rowEditingAccessorySize, MAXFLOAT);
			break;
			
		default:
			break;
	}
	CGSize suggestedSize = [text sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:UILineBreakModeWordWrap];
	
	return suggestedSize.height;
}

- (CGFloat) calculateCellHeightForMultiLineString: (NSString *)text
{
	return [self calculateCellHeightForMultiLineString:text ofFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
}

- (CGFloat) calculateCellHeightForMultiLineString: (NSString *)text ofFont:(UIFont *)font
{
	return [self calculateLabelHeightForMultiLineString:text ofFont:font] + 15;
}

@end