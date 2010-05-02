//
//  CDLToManyRelationshipAddNewObjectTableRowController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the BSD License
//
//  code.google.com/p/coredatalibrary
//

#import "CDLToManyRelationshipAddNewObjectTableRowController.h"
#import "CDLToManyRelationshipAddNewObjectEditController.h"
#import "CDLToManyRelationshipSectionController.h"
@implementation CDLToManyRelationshipAddNewObjectTableRowController


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	cell.textLabel.text = [NSString stringWithFormat:@"Add New %@", self.rowLabel];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	CDLToManyRelationshipAddNewObjectEditController *fieldEditController = [[CDLToManyRelationshipAddNewObjectEditController alloc] initForPropertyList:[[NSBundle mainBundle] pathForResource:((CDLToManyRelationshipSectionController *)self.sectionController).addNewObjectPropertyListFile ofType:@"plist"] editingObject:[self.delegate managedObject] relationshipEntityName:self.relationshipEntityName relationshipKey:self.sectionController.keyForRelationship label:self.rowLabel];
	
	
	
	fieldEditController.delegate = (id<CDLFieldEditControllerDelegate>) self.delegate; //we know the delegate of this class will be a CDLToManyOrderedRelationshipSectionController which implements this protocol
	
	[self.delegate pushViewController:fieldEditController animated:YES];
	[fieldEditController release];
}
@end
