//
//  CDLToManyOrderedRelationshipAddTableRowController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import "CDLToManyOrderedRelationshipSectionController.h"

#import "CDLToManyOrderedRelationshipAddTableRowController.h"

#import "CDLToManyOrderedRelationshipEditController.h"

@implementation CDLToManyOrderedRelationshipAddTableRowController

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

- (NSString *) relationshipIntermediateEntityName
{
	return ((CDLToManyOrderedRelationshipSectionController *)self.sectionController).relationshipIntermediateEntityName;
}

- (NSString *) relationshipEntityName
{
	return ((CDLToManyOrderedRelationshipSectionController *)self.sectionController).relationshipEntityName;
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
	
	cell.textLabel.text = [NSString stringWithFormat:@"Add %@", self.rowLabel];
	
	return cell;
}


//allow selection
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	CDLToManyOrderedRelationshipEditController *fieldEditController = [[CDLToManyOrderedRelationshipEditController alloc] initForManagedObject:[self.sectionController managedObject] withLabel:self.rowLabel forKeyPath:self.attributeKeyPath forChoicesEntity:self.relationshipEntityName];
	
	[fieldEditController setInAddMode:self.inAddMode];
	fieldEditController.intermediateEntityName = self.relationshipIntermediateEntityName;
	
	fieldEditController.delegate = (id<CDLFieldEditControllerDelegate>) self.sectionController; //we know the delegate of this class will be a CDLToManyOrderedRelationshipSectionController which implements this protocol
	
	[self.sectionController pushViewController:fieldEditController animated:YES];
	[fieldEditController release];
}


#pragma mark -
#pragma mark table view delegate - optional

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleInsert) { //press of the green plus button
		[self tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

@end
