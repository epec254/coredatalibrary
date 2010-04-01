//
//  ManagedObjectDetailViewSectionController.m
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLTableSectionController.h"
#import "CDLRelationshipTableRowController.h"
#import "CDLToManyOrderedRelationshipSectionController.h"
@interface CDLTableSectionController(PrivateMethods)
+ (CDLTableRowType) cellTypeOfRowFromDictionary:(NSDictionary *) rowDictionary;
- (id) initForRowDictionaries:(NSArray *) rowDictionaries forSectionTitle:(NSString *)sectionTitle forDelegate:(id<CDLTableSectionControllerDelegate>) delegate;
@end

@implementation CDLTableSectionController

@synthesize inAddMode = _inAddMode;
@synthesize sectionTitle = _sectionTitle;
@synthesize rowControllers = _rowControllers;
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark init

+ (CDLTableSectionController *) tableSectionControllerForDictionary:(NSDictionary *) sectionInformation forDelegate:(id<CDLTableSectionControllerDelegate>) delegate
{
	CDLTableSectionController *newTableSectionController = nil;
	
	NSString *aSectionTitle = [sectionInformation valueForKey:@"sectionTitle"];
	//We need to look at the first row and determine if its a MOTableRowTypeRelationship for a toMany relationship
	NSArray *rowDictionaries = [sectionInformation valueForKey:@"rowInformation"];
	
	if (rowDictionaries == nil || [rowDictionaries count] == 0) {
		NSException *ex = [NSException exceptionWithName:@"Row Information not valid" reason:NSLocalizedString(@"You must have at least 1 row in a section", @"You must have at least 1 row in a section") userInfo:nil];
		[ex raise];
	}
	
	id firstRowDictionary = [rowDictionaries objectAtIndex:0];
	
	if (![firstRowDictionary isKindOfClass:[NSDictionary class]]) {
		NSException *ex = [NSException exceptionWithName:@"Loaded row info not valid" reason:NSLocalizedString(@"Base class is not a dictionary", @"Base class is not a dictionary") userInfo:nil];
		[ex raise];
	}
	
	CDLTableRowType firstRowCellType = [CDLTableSectionController cellTypeOfRowFromDictionary:firstRowDictionary];
	
	if (firstRowCellType == CDLTableRowTypeToManyOrderedRelationship) {
		//do some processing
		newTableSectionController = [[CDLToManyOrderedRelationshipSectionController alloc] initForRowDictionaries:rowDictionaries forSectionTitle:aSectionTitle forDelegate:delegate];
	} else { //don't need a special section controller
		newTableSectionController = [[CDLTableSectionController alloc] initForRowDictionaries:rowDictionaries forSectionTitle:aSectionTitle forDelegate:delegate];
	}

	
	
	return [newTableSectionController autorelease];
}

+ (CDLTableRowType) cellTypeOfRowFromDictionary:(NSDictionary *) rowDictionary
{
	NSString *rowCellTypeString = [rowDictionary valueForKey:@"rowType"];
	
	if (rowCellTypeString == nil) {
		NSException *ex = [NSException exceptionWithName:@"Each row must provide a cell type" reason:NSLocalizedString(@"Each row must provide a cell type", @"Each row must provide a cell type") userInfo:nil];
		[ex raise];
	}
	
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
		[rowController setInAddMode:addMode];
	}
}

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

@end
