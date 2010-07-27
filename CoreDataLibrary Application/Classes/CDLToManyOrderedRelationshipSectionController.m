//
//  CDLToManyOrderedRelationshipSectionController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import "CDLDetailViewController.h"
#import "CDLToManyOrderedRelationshipSectionController.h"
#import "CDLToManyOrderedRelationshipAddTableRowController.h"
#import "CDLToManyOrderedRelationshipTableRowController.h"
#import "CDLTableSectionController.h"
#import "NSArray+Set.h"
#import "DataController.h"
#import "NSManagedObject+TypeOfProperty.h"

@interface CDLToManyOrderedRelationshipSectionController(PrivateMethods)
//- (id) initForRowDictionaries:(NSArray *) rowDictionaries forSectionTitle:(NSString *)sectionTitle forDetailView:(CDLDetailViewController *) owner;
- (id) initForDictionary:(NSDictionary *) sectionInformation forDetailView:(CDLDetailViewController *)owner;

- (NSManagedObject *) managedObjectFromRowControllerAtRow:(NSInteger) row;
- (void) _validateAndSetInstanceVariablesFromRowDictionaries:(NSArray *) rowDictionaries;

- (void) _buildRowControllersArray;

- (id<CDLTableRowControllerProtocol>) rowControllersForRow:(NSInteger) row;

@property (nonatomic, readonly) NSInteger _requiredNumberOfAttributesInKeyPath;

@end

@implementation CDLToManyOrderedRelationshipSectionController

@synthesize relationshipIntermediateEntityName = _relationshipIntermediateEntityName;


#pragma mark -
#pragma mark mem mgt
- (void)dealloc
{


	[_relationshipIntermediateEntityName release];
	_relationshipIntermediateEntityName = nil;

	[super dealloc];
}

#pragma mark -
#pragma mark private method overrides

#pragma mark setting variables

- (void) _discoverAndStoreRelationshipEntities
{
	NSManagedObject *theObject = [self.detailView managedObjectForSectionController:self];
	
	//1) should be toMany and cascade delete
	NSRelationshipDescription *theObjectToIntermediateObjectRelationship = nil;
	//2) should be toOne and nullify
	NSRelationshipDescription *intermediateObjectToFinalObjectRelationship = nil;
	
	//3) should be toOne and nullify
	NSRelationshipDescription *intermediateObjectToTheObjectRelationship = nil;
	//4) should be toMany and cascade delete
	NSRelationshipDescription *finalObjectToIntermediateObjectRelationship = nil;
	
	NSEntityDescription *theDescription = [theObject entity];
	
	
	//Get the name of the intermediate entity
	NSDictionary *relationshipsByName = [theDescription relationshipsByName];
	
	theObjectToIntermediateObjectRelationship = [relationshipsByName objectForKey:self.keyForRelationship];
	
	if (theObjectToIntermediateObjectRelationship == nil) {
		[CDLUtilityMethods raiseExceptionWithName:@"Invalid input for CDLToManyOrderedRelationshipSectionController" reason:@"Invalid keypath - intermediate relationship does not exist"];
	}
	//1) should be toMany and cascade delete
	if (![theObjectToIntermediateObjectRelationship isToMany] || [theObjectToIntermediateObjectRelationship deleteRule] != NSCascadeDeleteRule) {
		[CDLUtilityMethods raiseExceptionWithName:@"Invalid input for CDLToManyOrderedRelationshipSectionController" reason:@"Invalid intermediate relationship - must be toMany with a cascase delete rule"];
	}
	
	intermediateObjectToTheObjectRelationship = [theObjectToIntermediateObjectRelationship inverseRelationship];
	//3) should be toOne and nullify
	if ([intermediateObjectToTheObjectRelationship isToMany] || [intermediateObjectToTheObjectRelationship deleteRule] != NSNullifyDeleteRule) {
		[CDLUtilityMethods raiseExceptionWithName:@"Invalid input for CDLToManyOrderedRelationshipSectionController" reason:@"Invalid intermediate relationship - must be toMany with a cascase delete rule"];
	}
	
	
	//INTEMERDIATE ENTITY
	NSEntityDescription *intermediateEntityDescription = [theObjectToIntermediateObjectRelationship destinationEntity];
	self.relationshipIntermediateEntityName = [intermediateEntityDescription name];
	
	//Now, get the name of the destination entity
	NSArray *keyParts = [self.userProvidedFullKeyPath componentsSeparatedByString:@"."];
	
	relationshipsByName = [intermediateEntityDescription relationshipsByName];
	
	intermediateObjectToFinalObjectRelationship = [relationshipsByName objectForKey:[keyParts objectAtIndex:1]];
	
	if (intermediateObjectToFinalObjectRelationship == nil) {
		[CDLUtilityMethods raiseExceptionWithName:@"Invalid input for CDLToManyOrderedRelationshipSectionController" reason:@"Invalid keypath - destination relationship does not exist"];
	}
	//2) should be toOne and nullify
	if ([intermediateObjectToFinalObjectRelationship isToMany] || [intermediateObjectToFinalObjectRelationship deleteRule] != NSNullifyDeleteRule) {
		[CDLUtilityMethods raiseExceptionWithName:@"Invalid input for CDLToManyOrderedRelationshipSectionController" reason:@"Invalid destination relationship - must be toOne with a nullify delete rule"];
	}
	
	//4) should be toMany and cascade delete
	finalObjectToIntermediateObjectRelationship = [intermediateObjectToFinalObjectRelationship inverseRelationship];
	if (![finalObjectToIntermediateObjectRelationship isToMany] || [finalObjectToIntermediateObjectRelationship deleteRule] != NSCascadeDeleteRule) {
		[CDLUtilityMethods raiseExceptionWithName:@"Invalid input for CDLToManyOrderedRelationshipSectionController" reason:@"Invalid intermediate relationship - must be toMany with a cascase delete rule"];
	}
	
	
	self.relationshipEntityName = [[intermediateObjectToFinalObjectRelationship destinationEntity] name];

}

- (NSString *) sortKeyName
{
	return @"order";
}

//attributeKeyPath should be relationshipIntermediateEntityName.relationshipName.displayProperty
- (NSInteger) _requiredNumberOfAttributesInKeyPath
{
	return 3;
}


#pragma mark add row

- (id<CDLTableRowControllerProtocol>) addExistingObjectsRowController
{
	if (_addExistingObjectsRowController != nil) {
		return _addExistingObjectsRowController;
	}

	CDLToManyOrderedRelationshipAddTableRowController *aAddRowController = [[CDLToManyOrderedRelationshipAddTableRowController alloc] initForDictionary:self.rowInformation];
	//aAddRowController.delegate = self;
	aAddRowController.sectionController = self;
	
	_addExistingObjectsRowController = aAddRowController;
	
	return _addExistingObjectsRowController;
}

#pragma mark row information

- (NSDictionary *) rowInformation
{
	if (_rowInformation != nil) {
		return _rowInformation;
	}
	
	NSDictionary *modifiedRowDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
										   
										   self.userProvidedFullKeyPath, @"attributeKeyPath",  
										   // self.drillDownKeyPath, @"drillDownKeyPath",
										   @"CDLTableRowTypeToManyOrderedRelationship", @"rowType",
										   self.relationshipEntityName, @"relationshipEntityName",
										   self.relationshipIntermediateEntityName,@"relationshipIntermediateEntityName", 
										   self.rowLabel, @"rowLabel", nil];
	
	_rowInformation = [modifiedRowDictionary retain];
	
	return _rowInformation;
}


#pragma mark row controllers

- (id<CDLTableRowControllerProtocol>) _createRowControllerForRelationshipObject:(NSManagedObject *)relationshipObject
{
	return [[[CDLToManyOrderedRelationshipTableRowController alloc] initForDictionary:self.rowInformation forRelationshipObject:relationshipObject] autorelease];
}


#pragma mark -
#pragma mark row deletion

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		NSInteger row = indexPath.row;
		NSManagedObject *objectForRow = [self managedObjectFromRowControllerAtRow:row];
		
		
		NSString *attributeKeyFirstLetterCapitalized = [self.keyForRelationship stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.keyForRelationship substringToIndex:1] capitalizedString]];

		NSString *removeFunctionString = [NSString stringWithFormat:@"remove%@Object:", attributeKeyFirstLetterCapitalized];
		SEL removeFunction = NSSelectorFromString(removeFunctionString); //selector to remove the associated record
		
		//Remove the row controller
		[self.mutableRowControllers removeObjectAtIndex:row];
		
		//remove from the Managed Object
		[[self.detailView managedObjectForSectionController:self] performSelector:removeFunction withObject:objectForRow];
		
		//Remove from the context
		//cascade delete takes care of this.
		//[MANAGED_OBJECT_CONTEXT deleteObject:objectForRow];
		
		//Reorder the order property
		for (int i = 0; i < [self.mutableRowControllers count]; i++) {
			
			[[self managedObjectFromRowControllerAtRow:i] setValue:[NSNumber numberWithInt:i] forKey:self.sortKeyName];
		}
		
		//Update tableview	
		[tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
		
		if (!self.inAddMode) {
			[[DataController sharedDataController] saveFromSource:@"to many delete row"];
		}
	}  else {
		id rowController = [self rowControllersForRow:indexPath.row];
		if ([rowController respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
			return [rowController tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
		}
	}
	
}

#pragma mark -
#pragma mark row reordering

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	NSInteger targetRow = proposedDestinationIndexPath.row;
	NSInteger targetSection = proposedDestinationIndexPath.section;

	if (targetSection > sourceIndexPath.section) { //always stay in the same section
		targetSection = sourceIndexPath.section;
		targetRow = [self.mutableRowControllers count] - 2;
	} else if (targetSection < sourceIndexPath.section) { //always stay in the same section
		targetSection = sourceIndexPath.section;
		targetRow = 0;
	} else if (targetRow < 0) {
		targetRow = 0;
	} else if (targetRow >= [self.mutableRowControllers count] - 1) { //at or below add row, retarget for right above that.
		targetRow = [self.mutableRowControllers count] - 2;
	}

	return [NSIndexPath indexPathForRow:targetRow inSection:targetSection];
	
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	NSInteger row = fromIndexPath.row;
	//NSManagedObject *objectForRow = [self managedObjectFromRowControllerAtRow:row];
	id<CDLTableRowControllerProtocol> controllerForRow = [[self.mutableRowControllers objectAtIndex:row] retain];
	//update row controllers
	[self.mutableRowControllers removeObjectAtIndex:row];
	[self.mutableRowControllers insertObject:controllerForRow atIndex:toIndexPath.row];
	
	[controllerForRow release];

	//update order properties
	NSInteger start = fromIndexPath.row;
	if (toIndexPath.row < start) {
		start = toIndexPath.row;
	}
	NSInteger end = toIndexPath.row;
	if (fromIndexPath.row > end) {
		end = fromIndexPath.row;
	}

	for (NSInteger i = start; i <= end; i++) {
		[[self managedObjectFromRowControllerAtRow:i] setValue:[NSNumber numberWithInt:i] forKey:self.sortKeyName];
	}
	
	//save
	if (!self.inAddMode) {
		[[DataController sharedDataController] saveFromSource:@"to many change order"];
	}
	
}



#pragma mark -
#pragma mark row editing and section information

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView.editing) {
		return [self.mutableRowControllers count]; //show add row
	} else {
		return [self.mutableRowControllers count] - 1;
	}

}

#pragma mark -
#pragma mark field edit delegate

- (void) fieldEditController:(CDLAbstractFieldEditController *) controller didEndEditingCanceled: (BOOL) wasCancelled
{
	
	[self _buildRowControllersArray];
	
	[self.detailView reloadSectionController:self withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -
#pragma mark add mode

- (void) setInAddMode:(BOOL) addMode
{
	_inAddMode = addMode;
	
	for (id<CDLTableRowControllerProtocol> rowController in self.mutableRowControllers)
	{
		if ([rowController respondsToSelector:@selector(setInAddMode:)]) {
			[rowController setInAddMode:addMode];
		}
	}
}

@end
