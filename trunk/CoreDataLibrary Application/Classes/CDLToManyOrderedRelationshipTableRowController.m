//
//  MOToManyRelationshopRowController.m
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLToManyOrderedRelationshipTableRowController.h"
@interface CDLToManyOrderedRelationshipTableRowController(PrivateMethods)
- (NSString *) stringValueForKeyPath:(NSString *) keyPath inObject:(id) object;

@end

@implementation CDLToManyOrderedRelationshipTableRowController

@synthesize relationshipObject = _relationshipObject;

- (void)dealloc
{
	[_relationshipObject release];
	_relationshipObject = nil;

	[super dealloc];
}

#pragma mark -
#pragma mark init
- (id) initForDictionary:(NSDictionary *) rowInformation forRelationshipObject:(NSManagedObject *) relationshipObject
{
	if (self = [super initForDictionary:rowInformation]) {
		
		self.relationshipObject = relationshipObject;
		self.rowType = CDLTableRowTypeToManyOrderedRelationship;
		self.drillDownKeyPath = [rowInformation valueForKey:@"drillDownKeyPath"];
	}
	
	return self;
}



#pragma mark -
#pragma mark table view delegate methods - required

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *toManyRelationshipCell = @"ToManyRelationshipCell";
	
	UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
	NSString *cellIdentifier = toManyRelationshipCell;
	
	//Create the cell/get from the cache
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.editingAccessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	[self configureCell:cell forRowAtIndexPath:indexPath];
	
	return cell;
}

- (void) configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.textLabel.text = [self stringValueForKeyPath:self.keyPathForRelationshipDisplayProperty inObject:self.relationshipObject];
}

#pragma mark -
#pragma mark table view delegate - optional

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return nil; //no selection
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
