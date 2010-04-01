//
//  MOToManyRelationshipAddRowController.m
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLToManyOrderedRelationshipAddTableRowController.h"

#import "CDLToManyOrderedRelationshipAddController.h"

@implementation CDLToManyOrderedRelationshipAddTableRowController

@synthesize relationshipIntermediateEntityName = _relationshipIntermediateEntityName;
@synthesize relationshipEntityName = _relationshipEntityName;

- (void)dealloc
{
	[_relationshipEntityName release];
	_relationshipEntityName = nil;

	[_relationshipIntermediateEntityName release];
	_relationshipIntermediateEntityName = nil;

	[super dealloc];
}

#pragma mark -
#pragma mark init

- (id) initForDictionary:(NSDictionary *) rowInformation
{
	if (self = [super initForDictionary:rowInformation forRelationshipObject:nil]) {
		BOOL isValid = YES;
		NSString *error = @"Error(s): ";
		
		self.relationshipEntityName = [rowInformation valueForKey:@"relationshipEntityName"];
		self.relationshipIntermediateEntityName = [rowInformation valueForKey:@"relationshipIntermediateEntityName"];
		
		if (self.relationshipEntityName == nil || [self.relationshipEntityName length] == 0) {
			isValid = NO;
			error = [error stringByAppendingFormat:@"relationshipEntityName can't be null or zero length"];
		}
		
		if (self.relationshipIntermediateEntityName == nil || [self.relationshipIntermediateEntityName length] == 0) {
			isValid = NO;
			error = [error stringByAppendingFormat:@"relationshipIntermediateEntityName can't be null or zero length"];
		}
		
		if (!isValid) {
			NSException *ex = [NSException exceptionWithName:@"Invalid input for MOToManyRelationshipAddTableRowController" reason:error userInfo:nil];
			[ex raise];
		}
	}
	return self;
}

#pragma mark -
#pragma mark table view delegate methods - required

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *toManyRelationshipCell = @"ToManyRelationshipAddCell";
	
	UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
	NSString *cellIdentifier = toManyRelationshipCell;
	
	//Create the cell/get from the cache
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	[self configureCell:cell forRowAtIndexPath:indexPath];
	
	return cell;
}

- (void) configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.textLabel.text = [NSString stringWithFormat:@"Add %@", self.rowLabel];
}

//allow selection
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	CDLToManyOrderedRelationshipAddController *fieldEditController = [[CDLToManyOrderedRelationshipAddController alloc] initForManagedObject:[self.delegate managedObject] withLabel:self.rowLabel forKeyPath:self.attributeKeyPath forRelationshipEntity:self.relationshipEntityName];
	[fieldEditController setInAddMode:self.inAddMode];
	fieldEditController.relationshipIntermediateEntityName = self.relationshipIntermediateEntityName;
	fieldEditController.delegate = (id<CDLFieldEditControllerDelegate>) self.delegate; //we know the delegate of this class will be a MOToManyOrderedRelationshipSectionController which implements this protocol
	
	[self.delegate pushViewController:fieldEditController animated:YES];
	[fieldEditController release];
}

#pragma mark -
#pragma mark field edit delegate
- (void) fieldEditController:(CDLAbstractFieldEditController *) controller didEndEditing: (BOOL) wasCancelled
{
	//[self.delegate 
}

#pragma mark -
#pragma mark table view delegate - optional

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

@end
