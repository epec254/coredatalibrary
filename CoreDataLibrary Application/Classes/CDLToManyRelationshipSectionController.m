//
//  CDLToManyRelationshipSectionController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary
#import "NSArray+Set.h"
#import "CDLToManyRelationshipTableRowController.h"
#import "CDLToManyRelationshipAddExistingObjectsTableRowController.h"
#import "CDLToManyRelationshipAddNewObjectTableRowController.h"
#import "DataController.h"
#import "CDLToManyRelationshipSectionController.h"

@interface CDLToManyRelationshipSectionController(PrivateMethods)

@property (nonatomic, readonly) NSInteger _requiredNumberOfAttributesInKeyPath;

- (void) _validateAndSetInstanceVariablesFromRowDictionaries:(NSArray *) rowDictionaries;

- (void) _buildRowControllersArray;

- (CDLTableRowController *) _createRowControllerForRelationshipObject:(NSManagedObject *)relationshipObject;

- (void) _discoverAndStoreRelationshipEntities;

/** link to the add row controller */
@property (nonatomic, readonly) CDLTableRowController * addExistingObjectsRowController;
@property (nonatomic, readonly) CDLTableRowController * addNewObjectRowController;


@property (nonatomic, readonly) NSInteger numberOfAddRows;

@end

@implementation CDLToManyRelationshipSectionController

@synthesize addNewObjectPropertyListFile = _addNewObjectPropertyListFile;
@synthesize showAddExistingObjects = _showAddExistingObjects;
@synthesize showAddNewObject = _showAddNewObject;
@synthesize relationshipEntityName = _relationshipEntityName;
@synthesize rowLabel = _rowLabel;
@synthesize userProvidedFullKeyPath = _userProvidedFullKeyPath;
@synthesize drillDownKeyPath = _drillDownKeyPath;
//@synthesize sortedObjects = _sortedObjects;
@synthesize mutableRowControllers = _mutableRowControllers;
//@synthesize rowInformation = _rowInformation;

- (void)dealloc
{
	[_rowLabel release];
	_rowLabel = nil;
	
	[_userProvidedFullKeyPath release];
	_userProvidedFullKeyPath = nil;
	
	[_drillDownKeyPath release];
	_drillDownKeyPath = nil;
	
	[_mutableRowControllers release];
	_mutableRowControllers = nil;
	
	[_rowInformation release];
	_rowInformation = nil;

	[_relationshipEntityName release];
	_relationshipEntityName = nil;
	
	[_addExistingObjectsRowController release];
	_addExistingObjectsRowController = nil;


	[_addNewObjectPropertyListFile release];
	_addNewObjectPropertyListFile = nil;

	[super dealloc];
}

#pragma mark -
#pragma mark init method

- (id) initForRowDictionaries:(NSArray *) rowDictionaries forSectionTitle:(NSString *)sectionTitle forDelegate:(id<CDLTableSectionControllerDelegate>) delegate 
{
	if (self = [super init]) {
		
		/* At this point we know:
		 * 1) rowType is CDLTableRowTypeToManyRelationship
		 * 2) there is at least one element in rowDictionaries
		 * 3) the first element of rowDictionaries is valid.
		 * 4) sectionTitle is nil or has a non-zero length string
		 */
		
		self.sectionTitle = sectionTitle;
		self.delegate = delegate;
		
		/* Now we verify our input data */
		
		[self _validateAndSetInstanceVariablesFromRowDictionaries:rowDictionaries];
		
		[self _discoverAndStoreRelationshipEntities];
		
		//At this point, everything is valid or an exception was thrown.
		
		//Build the row controllers
		[self _buildRowControllersArray];
		
	}
	
	return self;
}

#pragma mark -
#pragma mark Private Methods

#pragma mark entity information

- (void) _discoverAndStoreRelationshipEntities
{
	NSManagedObject *theObject = [self.delegate managedObjectForSectionController:self];
	
	NSEntityDescription *theDescription = [theObject entity];
	
	NSDictionary *relationshipsByName = [theDescription relationshipsByName];
	
	NSRelationshipDescription *thisRelationship = [relationshipsByName objectForKey:self.keyForRelationship];
	
	if (thisRelationship == nil) {
		[CDLUtilityMethods raiseExceptionWithName:@"Invalid input for CDLToManyOrderedRelationshipSectionController" reason:@"Invalid keypath - intermediate relationship does not exist"];
	}
	
	self.relationshipEntityName = [[thisRelationship destinationEntity] name];
}


#pragma mark load from plist
//attributeKeyPath should be relationshipName.displayProperty
- (NSInteger) _requiredNumberOfAttributesInKeyPath
{
	return 2;
}

- (void) _validateAndSetInstanceVariablesFromRowDictionaries:(NSArray *) rowDictionaries
{
	/* Now we verify:
	 * 1) There is ONLY one element in rowDictionaries
	 * 2) rowLabel is provided and non-nil or zero-length
	 * 3) attributeKeyPath is provided, non-nil and is of the form relationshipName.displayProperty
	 * 4) if drillDownKeyPath is zero-length, revert it to nil
	 * 5) check showAddNewObject and showAddExistingObjects.  If neither are set, default to just showAddExistingObjects. If showAddNewObject is set, addNewObjectPropertyListFile must also be set.
	 */
	
	NSDictionary *providedRowController = [rowDictionaries objectAtIndex:0];
	
	NSMutableArray *inputValidationErrors = [[NSMutableArray alloc] init];
	
	// 1) There is ONLY one element in rowDictionaries
	if ([rowDictionaries count] != 1) 
	{
		[inputValidationErrors addObject:[NSString stringWithFormat:@"toMany relationship sections can only have one row definition, the rest are automatically created.  you have %d rows", [rowDictionaries count]]];
	}
	
	
	// 2) rowLabel is provided and non-nil or zero-length
	self.rowLabel = [providedRowController objectForKey:@"rowLabel"];
	if (![CDLUtilityMethods isLoadedStringValid:self.rowLabel]) {
		[inputValidationErrors addObject:@"rowLabel can't be null or zero length"];
	}
	
	// 3) attributeKeyPath is provided, non-nil and is of the form relationshipName.displayProperty
	self.userProvidedFullKeyPath = [providedRowController objectForKey:@"attributeKeyPath"];
	if (![CDLUtilityMethods isLoadedStringValid:self.userProvidedFullKeyPath]) {
		[inputValidationErrors addObject:@"attributeKeyPath can't be null or zero length"];
	}
	if ([[self.userProvidedFullKeyPath componentsSeparatedByString:@"."] count] != self._requiredNumberOfAttributesInKeyPath) {
		[inputValidationErrors addObject:[NSString stringWithFormat:@"attributeKeyPath must have %d parts", self._requiredNumberOfAttributesInKeyPath]];
	}
	
	// 4) if drillDownKeyPath is zero-length, revert it to nil
	self.drillDownKeyPath = [providedRowController objectForKey:@"drillDownKeyPath"];
	if (![CDLUtilityMethods isLoadedStringValid:self.drillDownKeyPath]) { //remove the empty strings
		self.drillDownKeyPath = nil;
	}
	
	// 5) check showAddNewObject and showAddExistingObjects.  If neither are set, default to just showAddExistingObjects. If showAddNewObject is set, addNewObjectPropertyListFile must also be set.
	
	self.showAddNewObject = [[providedRowController objectForKey:@"showAddNewObject"] boolValue]; //defaults to NO if not set
	self.showAddExistingObjects = [[providedRowController objectForKey:@"showAddExistingObjects"] boolValue]; //defaults to NO if not set
	self.addNewObjectPropertyListFile = [providedRowController objectForKey:@"addNewObjectPropertyListFile"];
	if (!self.showAddNewObject && ! self.showAddExistingObjects) {
		//neither set, default to showAddExistingObjects
		_showAddExistingObjects = YES;
	}
	if (self.showAddNewObject) {
		if (![CDLUtilityMethods isLoadedStringValid:self.addNewObjectPropertyListFile]) {
			[inputValidationErrors addObject:@"addNewObjectPropertyListFile must be set if showAddNewObject is YES"];
		}
	} else {
		self.addNewObjectPropertyListFile = nil;
	}

	
	//Raise an exception if any validation failed.
	if ([inputValidationErrors count] > 0) {
		[CDLUtilityMethods raiseExceptionWithName:@"Invalid input for CDLToMany*RelationshipSectionController" reason:[inputValidationErrors description]];
	}
	
	[inputValidationErrors release];
}

#pragma mark row information
- (NSDictionary *) rowInformation
{
	if (_rowInformation != nil) {
		return _rowInformation;
	}
	
	NSDictionary *modifiedRowDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.userProvidedFullKeyPath, @"attributeKeyPath", @"CDLTableRowTypeToManyRelationship", @"rowType", self.relationshipEntityName, @"relationshipEntityName", self.rowLabel, @"rowLabel", nil];
	
	_rowInformation = [modifiedRowDictionary retain];
	
	return _rowInformation;
}
#pragma mark row controllers

- (CDLTableRowController *) addExistingObjectsRowController
{
	if (!self.showAddExistingObjects) { //don't want to show this row controller.
		return nil;
	}
	
	if (_addExistingObjectsRowController != nil) {
		return _addExistingObjectsRowController;
	}
	CDLToManyRelationshipAddExistingObjectsTableRowController *aAddRowController = [[CDLToManyRelationshipAddExistingObjectsTableRowController alloc] initForDictionary:self.rowInformation];
	//aAddRowController.delegate = self;
	aAddRowController.sectionController = self;

	_addExistingObjectsRowController = aAddRowController;
	
	return _addExistingObjectsRowController;
}

- (CDLTableRowController *) addNewObjectRowController
{
	if (!self.showAddNewObject) { //don't want to show this row controller.
		return nil;
	}
	
	if (_addNewObjectRowController != nil) {
		return _addNewObjectRowController;
	}
	CDLToManyRelationshipAddNewObjectTableRowController *aAddRowController = [[CDLToManyRelationshipAddNewObjectTableRowController alloc] initForDictionary:self.rowInformation];
	//aAddRowController.delegate = self;
	aAddRowController.sectionController = self;
	
	_addNewObjectRowController = aAddRowController;
	
	return _addNewObjectRowController;
}



- (void) _buildRowControllersArray
{
	//Create the sorted set of relationship objects
	NSManagedObject *theManagedObject = [self.delegate managedObjectForSectionController:self];
	NSSet *unsortedObjectsAtRelationship = [theManagedObject valueForKey:self.keyForRelationship];
	
	NSArray *sortedObjectsAtRelationship = [NSArray arrayByOrderingSet:unsortedObjectsAtRelationship byKey:self.sortKeyName ascending:YES];
	
	NSMutableArray *theRowControllers = [[NSMutableArray alloc] init];
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	//Create each row controller
	for (int i = 0; i < [sortedObjectsAtRelationship count]; i++) {
		
		CDLTableRowController * aRowController = [self _createRowControllerForRelationshipObject:[sortedObjectsAtRelationship objectAtIndex:i]];
		
		aRowController.sectionController = self;
		
		[theRowControllers insertObject:aRowController atIndex:i];
			
	}
	[pool release];
	
	//put the add row controller(s) in there
	
	if (self.addExistingObjectsRowController != nil) {
		[theRowControllers insertObject:self.addExistingObjectsRowController atIndex:[theRowControllers count]];
	}
	
	if (self.addNewObjectRowController != nil) {
		[theRowControllers insertObject:self.addNewObjectRowController atIndex:[theRowControllers count]];
	}
	
	
	
	self.mutableRowControllers = theRowControllers;
	
	[theRowControllers release];
}


- (CDLTableRowController *) _createRowControllerForRelationshipObject:(NSManagedObject *)relationshipObject
{
	return [[[CDLToManyRelationshipTableRowController alloc] initForDictionary:self.rowInformation forRelationshipObject:relationshipObject] autorelease];
}

#pragma mark keys/variables
- (NSString *) sortKeyName
{
	return [[self.userProvidedFullKeyPath componentsSeparatedByString:@"."] objectAtIndex:1]; //if the keyPath is x.y, just get y
}

- (NSString *) keyForRelationship
{
	return [[self.userProvidedFullKeyPath componentsSeparatedByString:@"."] objectAtIndex:0]; //if the keyPath is x.y, just get X
}

- (NSInteger) numberOfAddRows
{
	NSInteger numberOfAddRows = 0;
	if (self.showAddNewObject)			numberOfAddRows++;
	if (self.showAddExistingObjects)	numberOfAddRows++;
	return numberOfAddRows;
}

#pragma mark -
#pragma mark row controllers/table view methods
- (CDLTableRowController *) rowControllersForRow:(NSInteger) row
{
	return (CDLTableRowController *) [self.mutableRowControllers objectAtIndex:row];
}


- (NSManagedObject *) managedObjectFromRowControllerAtRow:(NSInteger) row
{
	return [[self.mutableRowControllers objectAtIndex:row] relationshipObject];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	id rowController = [self rowControllersForRow:indexPath.row];
//	if ([rowController respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
//		return (UITableViewCellEditingStyle) [rowController tableView:tableView editingStyleForRowAtIndexPath:indexPath];
//	} else {
//		return UITableViewCellEditingStyleNone;
//	}
	
	if ([rowController respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
		return [rowController tableView:tableView canMoveRowAtIndexPath:indexPath];
	} else if ([self respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
		return YES;
	} else {
		return NO;
	}
}

#pragma mark -
#pragma mark row deletion
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id rowController = [self rowControllersForRow:indexPath.row];
	if ([rowController respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
		return (UITableViewCellEditingStyle) [rowController tableView:tableView editingStyleForRowAtIndexPath:indexPath];
	} else {
		return UITableViewCellEditingStyleNone;
	}
}

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
	

	
	//Update tableview	
	[self.delegate reloadSectionController:self withRowAnimation:UITableViewRowAnimationNone];

	
	if (!self.inAddMode) {
		[[DataController sharedDataController] saveFromSource:@"to many delete row"];
	}
	
	
	//[tableView endUpdates];
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
		return [self.mutableRowControllers count]; //show add row(s)
	} else {
		return [self.mutableRowControllers count] - self.numberOfAddRows;
	}
	
}

#pragma mark -
#pragma mark field edit delegate

- (void) fieldEditController:(CDLAbstractFieldEditController *) controller didEndEditingCanceled: (BOOL) wasCancelled
{
	[self _buildRowControllersArray];
	
	[self.delegate reloadSectionController:self withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -
#pragma mark add mode

- (void) setInAddMode:(BOOL) addMode
{
	_inAddMode = addMode;
	
	for (CDLTableRowController * rowController in self.mutableRowControllers)
	{
		if ([rowController respondsToSelector:@selector(setInAddMode:)]) {
			[rowController setInAddMode:addMode];
		}
	}
}


@end
