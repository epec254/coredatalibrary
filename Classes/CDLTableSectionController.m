//
//  CDLTableSectionController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the BSD License
//
//  code.google.com/p/coredatalibrary
#import "CDLToManyRelationshipSectionController.h"

#import "CDLTableSectionController.h"
#import "CDLRelationshipTableRowController.h"
#import "CDLToManyOrderedRelationshipSectionController.h"
@interface CDLTableSectionController(PrivateMethods)
+ (CDLTableRowType) cellTypeOfRowFromDictionary:(NSDictionary *) rowDictionary;
- (id) initForRowDictionaries:(NSArray *) rowDictionaries forSectionTitle:(NSString *)sectionTitle forDelegate:(id<CDLTableSectionControllerDelegate>) delegate;
- (id<CDLTableRowControllerProtocol>) rowControllersForRow:(NSInteger) row;

@end

@implementation CDLTableSectionController

@synthesize inAddMode = _inAddMode;
@synthesize sectionTitle = _sectionTitle;
@synthesize rowControllers = _rowControllers;
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark mem mgt 

- (void)dealloc
{
	[_sectionTitle release];
	_sectionTitle = nil;
	
	[_rowControllers release];
	_rowControllers = nil;
	
	
	[super dealloc];
}

#pragma mark -
#pragma mark init

+ (id<CDLTableSectionControllerProtocol>) tableSectionControllerForDictionary:(NSDictionary *) sectionInformation forDelegate:(id<CDLTableSectionControllerDelegate>) delegate
{
	CDLTableSectionController *newTableSectionController = nil;
	
	/* Verify the following:
	 * 1) rowInformation is an NSDictionary with more than 0 objects
	 * 2) if aSectionTitle is zero-length, replace it with nil.
	 * 3) verify the first row dictionary is of type NSDictionary and not empty
	 */
	
	// 1) rowInformation is an NSDictionary with more than 0 objects
	NSArray *rowDictionaries = [sectionInformation valueForKey:@"rowInformation"];
	if (![CDLUtilityMethods isLoadedArrayValid:rowDictionaries]) {
		[CDLUtilityMethods raiseExceptionWithName:@"rowInformation not valid" reason:@"rowInformation is not a NSArray or has 0 objects"];
	}

	// 2) if aSectionTitle is zero-length, replace it with nil.
	NSString *aSectionTitle = [sectionInformation valueForKey:@"sectionTitle"];
	if (![CDLUtilityMethods isLoadedStringValid:aSectionTitle]) {
		aSectionTitle = nil;
	}
	
	// 3) verify the first row dictionary is of type NSDictionary and not empty
	id firstRowDictionary = [rowDictionaries objectAtIndex:0];
	if (![CDLUtilityMethods isLoadedDictionaryValid:firstRowDictionary]) {
		[CDLUtilityMethods raiseExceptionWithName:@"first row in rowInformation not valid" reason:@"first row is not a NSDictionary or has 0 objects"];
	}
	
	/* Now, we need to determine the type of sectionController to create based on the rowType of the first row dictionary:
	 * 1) type CDLTableRowTypeToManyOrderedRelationship = CDLToManyOrderedRelationshipSectionController
	 * 2) type of CDLTableRowTypeOrderedRelationship = CDLToManyRelationshipSectionController
	 * 3) everything else = CDLTableSectionController
	 */
	
	// What is the row type?
	// An exception will be thrown here if this rowType is invalid
	CDLTableRowType firstRowCellType = [CDLTableSectionController cellTypeOfRowFromDictionary:firstRowDictionary];
	
	switch (firstRowCellType) {
		case CDLTableRowTypeToManyOrderedRelationship:
			// 1) type CDLTableRowTypeToManyOrderedRelationship = CDLToManyOrderedRelationshipSectionController
			newTableSectionController = [[CDLToManyOrderedRelationshipSectionController alloc] initForRowDictionaries:rowDictionaries forSectionTitle:aSectionTitle forDelegate:delegate];
			break;
		case CDLTableRowTypeToManyRelationship:
			// 2) type of CDLTableRowTypeOrderedRelationship = CDLToManyRelationshipSectionController
			newTableSectionController = [[CDLToManyRelationshipSectionController alloc] initForRowDictionaries:rowDictionaries forSectionTitle:aSectionTitle forDelegate:delegate];
			break;
		default:
			//3) everything else = CDLTableSectionController
			newTableSectionController = [[CDLTableSectionController alloc] initForRowDictionaries:rowDictionaries forSectionTitle:aSectionTitle forDelegate:delegate];
			break;
	}
	
	return [newTableSectionController autorelease];
}

+ (CDLTableRowType) cellTypeOfRowFromDictionary:(NSDictionary *) rowDictionary
{
	NSString *rowCellTypeString = [rowDictionary valueForKey:@"rowType"];
	
	return [CDLTableRowController cellTypeEnumFromString:rowCellTypeString];
}

- (id) initForRowDictionaries:(NSArray *) rowDictionaries forSectionTitle:(NSString *)sectionTitle forDelegate:(id<CDLTableSectionControllerDelegate>) delegate
{
	if (self = [super init]) {
		self.sectionTitle = sectionTitle;
		self.delegate = delegate;
		
		NSMutableArray *theRowControllers = [[NSMutableArray alloc] init];
		
		//Create a row controller for each row
		for (int i = 0; i < [rowDictionaries count]; i++) {
			
			
			id rowInformation = [rowDictionaries objectAtIndex:i];
			
			if (![rowInformation isKindOfClass:[NSDictionary class]]) {
				NSException *ex = [NSException exceptionWithName:@"Loaded row info not valid" reason:NSLocalizedString(@"Base class is not a dictionary", @"Base class is not a dictionary") userInfo:nil];
				[ex raise];
			}

			id<CDLTableRowControllerProtocol> aRowController = [CDLTableRowController tableRowControllerForDictionary:rowInformation forDelegate:self];;

			
			//aRowController.delegate = self;
			
			[theRowControllers insertObject:aRowController atIndex:i];
			
		}
		
		self.rowControllers = [NSArray arrayWithArray:theRowControllers];
		[theRowControllers release];
	}
	
	return self;
	
}

#pragma mark -
#pragma mark table view delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.rowControllers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return self.sectionTitle;
}

#pragma mark -
#pragma mark tableview delegates to row controllers

- (id<CDLTableRowControllerProtocol>) rowControllersForRow:(NSInteger) row
{
	return (id<CDLTableRowControllerProtocol>) [self.rowControllers objectAtIndex:row];
}

#pragma mark required methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<CDLTableRowControllerProtocol> rowController = [self rowControllersForRow:indexPath.row];
	
	return [rowController tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<CDLTableRowControllerProtocol> rowController = [self rowControllersForRow:indexPath.row];
	
	return [rowController tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark optional methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<CDLTableRowControllerProtocol> rowController = [self rowControllersForRow:indexPath.row];
	if ([rowController respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
		return [rowController tableView:tableView heightForRowAtIndexPath:indexPath];
	} else {
		return tableView.rowHeight;
	}
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<CDLTableRowControllerProtocol> rowController = [self rowControllersForRow:indexPath.row];
	if ([rowController respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
		return [rowController tableView:tableView willSelectRowAtIndexPath:indexPath];
	} else {
		return (tableView.editing) ? indexPath : nil;
	}
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<CDLTableRowControllerProtocol> rowController = [self rowControllersForRow:indexPath.row];
	if ([rowController respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]) {
		return [rowController tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
	} else {
		return NO;
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<CDLTableRowControllerProtocol> rowController = [self rowControllersForRow:indexPath.row];
	if ([rowController respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
		return [rowController tableView:tableView editingStyleForRowAtIndexPath:indexPath];
	} else {
		return UITableViewCellEditingStyleNone;
	}
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<CDLTableRowControllerProtocol> rowController = [self rowControllersForRow:indexPath.row];
	if ([rowController respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
		return [rowController tableView:tableView canEditRowAtIndexPath:indexPath];
	} else {
		return YES;
	}
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<CDLTableRowControllerProtocol> rowController = [self rowControllersForRow:indexPath.row];
	if ([rowController respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
		return [rowController tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
	} else {
		return;
	}
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<CDLTableRowControllerProtocol> rowController = [self rowControllersForRow:indexPath.row];
	if ([rowController respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
		return [rowController tableView:tableView canMoveRowAtIndexPath:indexPath];
	} else {
		return NO;
	}
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	return;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	for (id<CDLTableRowControllerProtocol> rowController in self.rowControllers)
	{
		if ([rowController respondsToSelector:@selector(setEditing:animated:)]) {
			[rowController setEditing:editing animated:animated];
		}
	}
}
#pragma mark -
#pragma mark row controller delegate

- (Class) classOfManagedObject
{
	return [self.delegate classOfManagedObject];
}
- (NSManagedObject *) managedObject
{
	return [self.delegate managedObjectForSectionController:self];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[self.delegate pushViewController:viewController animated:animated];
}

#pragma mark -
#pragma mark add mode

- (void) setInAddMode:(BOOL) addMode
{
	_inAddMode = addMode;
	
	for (id<CDLTableRowControllerProtocol> rowController in self.rowControllers)
	{
		if ([rowController respondsToSelector:@selector(setInAddMode:)]) {
			[rowController setInAddMode:addMode];
		}
	}
}

#pragma mark -
#pragma mark field edit view delegates
- (void) fieldEditController:(CDLAbstractFieldEditController *) controller didEndEditingCanceled: (BOOL) wasCancelled
{	
	[self.delegate reloadSectionController:self withRowAnimation:UITableViewRowAnimationFade];
}



@end
