//
//  CDLToManyRelationshipAddTableRowController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary
//

#import "CDLToManyRelationshipAddExistingObjectsTableRowController.h"
#import "CDLToManyRelationshipSectionController.h"
#import "CDLToManyRelationshipAddExistingObjectsEditController.h"

@implementation CDLToManyRelationshipAddExistingObjectsTableRowController

//@synthesize sectionController = _sectionController;

- (void)dealloc
{
	

	[super dealloc];
}
#pragma mark -
#pragma mark init
- (id) initForDictionary:(NSDictionary *) rowInformation
{
	if (self = [super initForDictionary:rowInformation forRelationshipObject:nil]) {
		
	}
	return self;
}

#pragma mark -
#pragma mark info from section controller


- (NSString *) relationshipEntityName
{
	return ((CDLToManyRelationshipSectionController *)self.sectionController).relationshipEntityName;
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
	
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *) indexPath
{
	cell.textLabel.text = [NSString stringWithFormat:@"Add Existing %@", self.rowLabel];
}

//allow selection
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	CDLToManyRelationshipAddExistingObjectsEditController *fieldEditController = [[CDLToManyRelationshipAddExistingObjectsEditController alloc] initForManagedObject:[self.sectionController managedObject] withLabel:self.rowLabel forKeyPath:self.attributeKeyPath forChoicesEntity:self.relationshipEntityName];
	
	[fieldEditController setInAddMode:self.inAddMode];
	
	fieldEditController.delegate = (id<CDLFieldEditControllerDelegate>) self.sectionController; //we know the delegate of this class will be a CDLToManyOrderedRelationshipSectionController which implements this protocol
	
	[self.sectionController pushViewController:fieldEditController animated:YES];
	[fieldEditController release];
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
