//
//  CDLToManyRelationshipAddNewObjectTableRowController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary
//

#import "CDLToManyRelationshipAddNewObjectTableRowController.h"
#import "CDLToManyRelationshipAddNewObjectEditController.h"
#import "CDLToManyRelationshipSectionController.h"
@implementation CDLToManyRelationshipAddNewObjectTableRowController


- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *) indexPath
{
	cell.textLabel.text = [NSString stringWithFormat:@"Add New %@", self.rowLabel];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	CDLToManyRelationshipAddNewObjectEditController *fieldEditController = [[CDLToManyRelationshipAddNewObjectEditController alloc] initForPropertyList:[[NSBundle mainBundle] pathForResource:((CDLToManyRelationshipSectionController *)self.sectionController).addNewObjectPropertyListFile ofType:@"plist"] editingObject:[self.sectionController managedObject] relationshipEntityName:self.relationshipEntityName relationshipKey:((CDLToManyRelationshipSectionController *)self.sectionController).keyForRelationship label:self.rowLabel];
	
	
	
	fieldEditController.delegate = (id<CDLFieldEditControllerDelegate>) self.sectionController; //we know the sectionController of this class will be a CDLToManyOrderedRelationshipSectionController which implements this protocol
	
	[self.sectionController pushViewController:fieldEditController animated:YES];
	[fieldEditController release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleInsert) { //press of the green plus button
		[self tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}
@end
