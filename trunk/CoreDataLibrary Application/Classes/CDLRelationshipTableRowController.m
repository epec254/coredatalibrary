//
//  MORelationshipTableRowController.m
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLRelationshipTableRowController.h"
#import "UIColor+MoreColors.h"
#import <objc/runtime.h>
#import <objc/message.h>

#import "CDLToOneRelationshipEditController.h"

@interface CDLRelationshipTableRowController(PrivateMethods)
//@property (nonatomic, readonly) BOOL isToManyRelationship; //Does the attributeKeyPath represent a NSSet, which is indicative of a toMany relationship
@property (nonatomic, readonly) BOOL useDrillDown;
@end

@implementation CDLRelationshipTableRowController
@synthesize drillDownKeyPath = _drillDownKeyPath;
//@synthesize delegate = _delegate;
#pragma mark -
#pragma mark init

- (id) initForDictionary:(NSDictionary *) rowInformation
{
	if (self = [super initForDictionary:rowInformation]) {
		
		BOOL isValid = YES;
		NSString *error = @"Error(s): ";
		
		if (self.rowType != CDLTableRowTypeRelationship && self.rowType != CDLTableRowTypeToManyOrderedRelationship) {
			error = [error stringByAppendingFormat:@"MORelationshipTableRowController requires a row type of MOTableRowTypeRelationship or MOTableRowTypeToManyOrderedRelationship (You provided %@)", self.rowType];
			isValid = NO;
		}
		
		if (self.rowType == CDLTableRowTypeRelationship && [[self.attributeKeyPath componentsSeparatedByString:@"."] count] != 2) {
			error = [error stringByAppendingFormat:@"MORelationshipTableRowControllers of type MOTableRowTypeRelationship requires a keyPath of form attribute.displayProperty (You provided %@)", self.attributeKeyPath];
			isValid = NO;
		}
		
		if (!isValid) {
			NSException *ex = [NSException exceptionWithName:@"Invalid input for MORelationshipTableRowController" reason:error userInfo:nil];
			[ex raise];
		}
		
		self.drillDownKeyPath = [rowInformation valueForKey:@"drillDownKeyPath"];
	}
	return self;
}

- (NSString *) keyForRelationship
{
	return [[self.attributeKeyPath componentsSeparatedByString:@"."] objectAtIndex:0]; //if the keyPath is x.y, just get X
}

- (NSString *) keyPathForRelationshipDisplayProperty
{
	//Get the rest of the keyPath aside from the direct relationship
	
	NSString *firstPartOfKeyPath = self.keyForRelationship;
	NSRange firstPartOfKeyPathRange = NSMakeRange(0, [firstPartOfKeyPath length] + 1);//include room for the .
	
	NSString *restOfKeyPath = self.attributeKeyPath;
	
	restOfKeyPath = [restOfKeyPath stringByReplacingCharactersInRange:firstPartOfKeyPathRange withString:@""];
	
	return restOfKeyPath;
}


#pragma mark -
#pragma mark type of property 

- (BOOL) useDrillDown
{
	return self.drillDownKeyPath != nil;
}

#pragma mark -
#pragma mark required CDLTableRowControllerProtocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellTypeSingleLineLargeLabelInCell = @"CellTypeSingleLineLabelInCellLargeCell";
	
	UITableViewCell *cell = nil;
	UITableViewCellStyle cellStyle = UITableViewCellStyleValue1;
	NSString *cellIdentifier = CellTypeSingleLineLargeLabelInCell;
	
	//Create the cell/get from the cache
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	//Place the attribute values/labels based on type of cell
	cell.detailTextLabel.text = self.attributeStringValue;
	cell.textLabel.text = self.rowLabel;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Push edit controller
	CDLToOneRelationshipEditController *fieldEditController = [[CDLToOneRelationshipEditController alloc] initForManagedObject:[self.delegate managedObject] withLabel:self.rowLabel forKeyPath:self.attributeKeyPath];
	
		[fieldEditController setInAddMode:self.inAddMode];
	[self.delegate pushViewController:fieldEditController animated:YES];
	
	[fieldEditController release];
}

#pragma mark -
#pragma mark mem mgt

- (void)dealloc
{
	[_drillDownKeyPath release];
	_drillDownKeyPath = nil;
	
	
	
	[super dealloc];
}

@end
