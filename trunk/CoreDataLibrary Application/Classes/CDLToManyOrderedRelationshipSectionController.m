//
//  MOToManyRelationshipSectionController.m
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLToManyOrderedRelationshipSectionController.h"
#import "CDLToManyOrderedRelationshipAddTableRowController.h"
#import "CDLToManyOrderedRelationshipTableRowController.h"
#import "CDLTableSectionController.h"
#import "NSArray+Set.h"
#import "DataController.h"
#import "NSManagedObject+TypeOfProperty.h"

@interface CDLToManyOrderedRelationshipSectionController(PrivateMethods)
- (id) initForRowDictionaries:(NSArray *) rowDictionaries forSectionTitle:(NSString *)sectionTitle forDelegate:(id<CDLTableSectionControllerDelegate>) delegate;

- (NSManagedObject *) managedObjectFromRowControllerAtRow:(NSInteger) row;

- (void) buildRowControllersArray;
@end

@implementation CDLToManyOrderedRelationshipSectionController

@synthesize entityTypeOfOrderedRelationship = _entityTypeOfOrderedRelationship;
@synthesize mutableRowControllers = _mutableRowControllers;
@synthesize rowInformation = _rowInformation;
@synthesize drillDownKeyPath = _drillDownKeyPath;
@synthesize rowLabel = _rowLabel;
@synthesize userProvidedFullKeyPath = _userProvidedFullKeyPath;
@synthesize addRowController = _addRowController;

#pragma mark -
#pragma mark mem mgt
- (void)dealloc
{
	[_addRowController release];
	_addRowController = nil;

	[_rowLabel release];
	_rowLabel = nil;
	[_userProvidedFullKeyPath release];
	_userProvidedFullKeyPath = nil;

	[_sortedObjects release];
	_sortedObjects = nil;

	[_drillDownKeyPath release];
	_drillDownKeyPath = nil;

	[_rowInformation release];
	_rowInformation = nil;

	[_mutableRowControllers release];
	_mutableRowControllers = nil;

	[_entityTypeOfOrderedRelationship release];
	_entityTypeOfOrderedRelationship = nil;

	[super dealloc];
}

#pragma mark -
#pragma mark init method

- (id) initForRowDictionaries:(NSArray *) rowDictionaries forSectionTitle:(NSString *)sectionTitle forDelegate:(id<CDLTableSectionControllerDelegate>) delegate 
{
	if (self = [super init]) {
		BOOL isValid = YES;
		NSString *error = @"Error(s): ";
		
		if ([rowDictionaries count] != 1) 
		{
			error = [error stringByAppendingFormat:@"toMany relationship sections can only have one row definition, the rest are automatically created.  you have %d rows", [rowDictionaries count]];
			isValid = NO;
		}

		
		self.sectionTitle = sectionTitle;
		self.delegate = delegate;
		
		//at this point, we know that there is ONE object in the row and it is of type NSDictionary (this method is only called from the MOTableSectionController tableSectionControllerForDictionary method.
		
		NSDictionary *providedRowController = [rowDictionaries objectAtIndex:0];
		self.rowLabel = [providedRowController objectForKey:@"rowLabel"];
		self.userProvidedFullKeyPath = [providedRowController objectForKey:@"attributeKeyPath"];
		
		if (self.rowLabel == nil || [self.rowLabel length] == 0) {
			isValid = NO;
			error = [error stringByAppendingFormat:@"rowLabel can't be null or zero length"];
		}
		
		if (self.userProvidedFullKeyPath == nil || [self.userProvidedFullKeyPath length] == 0) {
			isValid = NO;
			error = [error stringByAppendingFormat:@"attributeKeyPath can't be null or zero length"];
		}
		
		if (!isValid) {
			NSException *ex = [NSException exceptionWithName:@"Invalid input for MOToManyOrderedRelationshipSectionController" reason:error userInfo:nil];
			[ex raise];
		}
		
		//End of validation
		
		self.drillDownKeyPath = [providedRowController objectForKey:@"drillDownKeyPath"];
		if ([self.drillDownKeyPath length] == 0) { //remove the empty strings
			self.drillDownKeyPath = nil;
		}
		
		//these properties will be verified and stored by the AddRowController
		NSString *relationshipEntityName = [providedRowController objectForKey:@"relationshipEntityName"];
		
		//NSString *intermediateObjectKey = [[self.delegate managedObjectForSectionController:self] classOfKey:[[self.userProvidedFullKeyPath componentsSeparatedByString:@"."] objectAtIndex:0]];
		
		self.entityTypeOfOrderedRelationship = [providedRowController objectForKey:@"relationshipIntermediateEntityName"];
		
		//[NSString stringWithFormat:@"%@To%@", intermediateObjectKey, relationshipEntityName];
		
		//
		
		//Create the add row
		NSDictionary *modifiedRowDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.rowLabel, @"rowLabel", self.userProvidedFullKeyPath, @"attributeKeyPath",  self.drillDownKeyPath, @"drillDownKeyPath", @"MOTableRowTypeToManyOrderedRelationship", @"rowType", relationshipEntityName, @"relationshipEntityName", self.entityTypeOfOrderedRelationship, @"relationshipIntermediateEntityName", nil];
		
		CDLToManyOrderedRelationshipAddTableRowController *aAddRowController = [[CDLToManyOrderedRelationshipAddTableRowController alloc] initForDictionary:modifiedRowDictionary];
		aAddRowController.delegate = self;
		self.addRowController = aAddRowController;
		[aAddRowController release];
		
		//Store the row information for future creation of rows
		self.rowInformation = modifiedRowDictionary;
		
		
		//Build the row controllers
		[self buildRowControllersArray];
		
	}
	
	return self;
}

- (void) buildRowControllersArray
{
	//Create the sorted set of relationship objects
	NSManagedObject *theManagedObject = [self.delegate managedObjectForSectionController:self];
	NSSet *unsortedObjectsAtRelationship = [theManagedObject valueForKey:self.keyForRelationship];
	
	NSArray *sortedObjectsAtRelationship = [NSArray arrayByOrderingSet:unsortedObjectsAtRelationship byKey:ORDER_KEY_NAME ascending:YES];
	
	NSMutableArray *theRowControllers = [[NSMutableArray alloc] init];
	
	//Create each row controller
	for (int i = 0; i < [sortedObjectsAtRelationship count]; i++) {
		
		id<CDLTableRowControllerProtocol> aRowController = [[CDLToManyOrderedRelationshipTableRowController alloc] initForDictionary:self.rowInformation forRelationshipObject:[sortedObjectsAtRelationship objectAtIndex:i]];
		
		aRowController.delegate = self;
		
		[theRowControllers insertObject:aRowController atIndex:i];
		
		[aRowController release];
		
	}
	
	//put the add row controller in there
	[theRowControllers insertObject:self.addRowController atIndex:[theRowControllers count]];
	
	self.mutableRowControllers = theRowControllers;
	
	[theRowControllers release];
	
}

- (NSString *) keyForRelationship
{
	return [[self.userProvidedFullKeyPath componentsSeparatedByString:@"."] objectAtIndex:0]; //if the keyPath is x.y, just get X
}
							  
#pragma mark -
#pragma mark row controllers/table view methods
- (id<CDLTableRowControllerProtocol>) rowControllersForRow:(NSInteger) row
{
	return (id<CDLTableRowControllerProtocol>) [self.mutableRowControllers objectAtIndex:row];
}


- (NSManagedObject *) managedObjectFromRowControllerAtRow:(NSInteger) row
{
	return [[self.mutableRowControllers objectAtIndex:row] relationshipObject];
}


#pragma mark -
#pragma mark row deletion

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	//	[tableView beginUpdates];
	
	NSInteger row = indexPath.row;
	NSManagedObject *objectForRow = [self managedObjectFromRowControllerAtRow:row];
	
	
	NSString *attributeKeyFirstLetterCapitalized = [self.keyForRelationship stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.keyForRelationship substringToIndex:1] capitalizedString]];

	NSString *removeFunctionString = [NSString stringWithFormat:@"remove%@Object:", attributeKeyFirstLetterCapitalized];
	SEL removeFunction = NSSelectorFromString(removeFunctionString); //selector to remove the associated record
	
	//Remove the row controller
	[self.mutableRowControllers removeObjectAtIndex:row];
	
	//remove from the Managed Object
	[[self.delegate managedObjectForSectionController:self] performSelector:removeFunction withObject:objectForRow];
	
	//Remove from the context
	[MANAGED_OBJECT_CONTEXT deleteObject:objectForRow];
	
	//Reorder the order property
	for (int i = 0; i < [self.mutableRowControllers count]; i++) {
		
		[[self managedObjectFromRowControllerAtRow:i] setValue:[NSNumber numberWithInt:i] forKey:ORDER_KEY_NAME];
	}
	
	//Update tableview	
	[tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
	
	if (!self.inAddMode) {
		[[DataController sharedDataController] saveFromSource:@"to many delete row"];
	}
	
	
	//[tableView endUpdates];
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
		[[self managedObjectFromRowControllerAtRow:i] setValue:[NSNumber numberWithInt:i] forKey:ORDER_KEY_NAME];
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

- (void) fieldEditController:(CDLAbstractFieldEditController *) controller didEndEditing: (BOOL) wasCancelled
{
	//TODO: pass up to the detail view for it to reload this section
	//TODO: reload the rowControllers array
	
	[self buildRowControllersArray];
	
	[self.delegate reloadSectionController:self withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -
#pragma mark add mode

- (void) setInAddMode:(BOOL) addMode
{
	_inAddMode = addMode;
	
	for (id<CDLTableRowControllerProtocol> rowController in self.mutableRowControllers)
	{
		[rowController setInAddMode:addMode];
	}
}

@end
