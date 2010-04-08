//
//  MORelationshipTableRowController.m
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MORelationshipTableRowController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface MORelationshipTableRowController(PrivateMethods)
@property (nonatomic, readonly) BOOL isToManyRelationship; //Does the attributeKeyPath represent a NSSet, which is indicative of a toMany relationship
@property (nonatomic, readonly) BOOL useDrillDown;
@end

@implementation MORelationshipTableRowController
@synthesize drillDownKeyPath = _drillDownKeyPath;

#pragma mark -
#pragma mark init

- (id) initForDictionary:(NSDictionary *) rowInformation
{
	if (self = [super initForDictionary:rowInformation]) {
		
		if (self.rowType != MOTableRowTypeRelationship) {
			NSException *ex = [NSException exceptionWithName:@"Bad row information" reason:NSLocalizedString(@"rowType must be MOTableRowCellTypeRelationship to use this row controller", @"rowType must be MOTableRowCellTypeRelationship to use this row controller") userInfo:nil];
			[ex raise];
		}
		
		self.drillDownKeyPath = [rowInformation valueForKey:@"drillDownKeyPath"];
	}
	return self;
}

#pragma mark -
#pragma mark type of property 

- (BOOL) useDrillDown
{
	return self.drillDownKeyPath != nil;
}

- (BOOL) isToManyRelationship
{		
	NSString *attributeKey = [[self.attributeKeyPath componentsSeparatedByString:@"."] objectAtIndex:0]; //if the keyPath is x.y, just get X
	
	objc_property_t relationshipProperty = class_getProperty([self.delegate classOfManagedObject], [attributeKey cStringUsingEncoding:[NSString defaultCStringEncoding]]);
	
	NSString *relationshipAttributes = [NSString stringWithUTF8String: property_getAttributes(relationshipProperty)];
	
	return [relationshipAttributes rangeOfString:@"NSSet"].location != NSNotFound;
}

#pragma mark -
#pragma mark required MOTableRowControllerProtocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellTypeSingleLineNoLabel = @"CellTypeSingleLineNoLabelCell";
	static NSString *CellTypeSingleLineLargeLabelInCell = @"CellTypeSingleLineLabelInCellLargeCell";
	
	UITableViewCell *cell = nil;
	UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
	NSString *cellIdentifier = nil;
	
	if (!self.isToManyRelationship) {
		cellStyle = UITableViewCellStyleValue1;
		cellIdentifier = CellTypeSingleLineLargeLabelInCell;
	} else {
		cellStyle = UITableViewCellStyleDefault;
		cellIdentifier = CellTypeSingleLineNoLabel;
	}

	//Create the cell/get from the cache
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		

    }
	
	//Place the attribute values/labels based on type of cell
	if (!self.isToManyRelationship) {
		cell.detailTextLabel.text = self.attributeValue;
		cell.textLabel.text = self.rowLabel;
	} else {
		//TODO
		cell.textLabel.text = self.attributeValue;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//TODO: push edit controller
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
