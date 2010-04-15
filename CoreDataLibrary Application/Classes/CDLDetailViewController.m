//
//  CDLRootViewController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import "CDLDetailViewController.h"
#import "CDLTableSectionController.h"

@interface CDLDetailViewController(PrivateMethods)
@end

@implementation CDLDetailViewController

@synthesize sectionControllers = _sectionControllers;
@synthesize managedObject = _managedObject;

- (void)dealloc {
    [_managedObject release];
	_managedObject = nil;
	
	[_sectionControllers release];
	_sectionControllers = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark init

- (id) initForPropertyList:(NSString *) fullPathToPropertyListFile managedObject:(NSManagedObject *)managedObject
{
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.managedObject = managedObject;
		
		//load the plist and do a sanity check
		id loadedStructure = [[NSArray alloc] initWithContentsOfFile:fullPathToPropertyListFile];
		
		if (![CDLUtilityMethods isLoadedArrayValid:loadedStructure]) {
			NSException *ex = [NSException exceptionWithName:@"Provided plist is not valid." reason:@"Base class is not an NSArray or has no objects" userInfo:nil];
			[ex raise];
		}
				
		//temporary storage of the sectionControllers
		NSMutableArray *theSectionControllers = [[NSMutableArray alloc] init];
		
		
		for (int i = 0; i < [loadedStructure count]; i++) //loop through each section 
		{
			NSDictionary *sectionInfo = [loadedStructure objectAtIndex:i];
			
			if (![CDLUtilityMethods isLoadedDictionaryValid:sectionInfo]) {
				NSException *ex = [NSException exceptionWithName:@"Section within plist is not valid" reason:@"Each member must be an NSDictionary" userInfo:nil];
				[ex raise];
			}
			
			//Create the controller
			id<CDLTableSectionControllerProtocol> aSectionController = [CDLTableSectionController tableSectionControllerForDictionary:sectionInfo forDelegate:self];
			//Store it
			[theSectionControllers insertObject:aSectionController atIndex:i];
		}
		//Store the temporary array of controllers
		self.sectionControllers = [NSArray arrayWithArray:theSectionControllers];
		
		//Memory mgt
		[theSectionControllers release];
		[loadedStructure release];
		
		self.tableView.allowsSelectionDuringEditing = YES;
	}
	
	return self;
}



#pragma mark -
#pragma mark section controller delegate



- (NSManagedObject *) managedObjectForSectionController:(CDLTableSectionController *)sectionController
{
	return self.managedObject;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[self.navigationController pushViewController:viewController animated:animated];
}

- (void) reloadSectionController:(CDLTableSectionController *) sectionController withRowAnimation:(UITableViewRowAnimation) rowAnimation
{
	NSInteger section = [self.sectionControllers indexOfObject:sectionController];
	//	[self.tableView reloadData];
	
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:rowAnimation];
}

- (UITableView *) theTableView
{
	return self.tableView;
}

- (NSInteger)sectionOfSectionController:(id<CDLTableSectionControllerProtocol>) sectionController
{
	return [self.sectionControllers indexOfObject:sectionController];
}

- (void) presentActionSheet:(UIActionSheet *) actionSheet
{
	if (self.tabBarController != nil) {
		//present in tabBar
		[actionSheet showFromTabBar:self.tabBarController.tabBar];
	} else {
		[actionSheet showInView:self.view];
	}

}

#pragma mark -
#pragma mark view lifecycle

- (void)viewWillAppear:(BOOL)animated {	

    [super viewWillAppear:animated];
	
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	self.navigationItem.hidesBackButton = editing;
	
	//call on each section controller
	for (CDLTableSectionController *sectionController in self.sectionControllers) {
		[sectionController setEditing:editing animated:animated];
	}
	
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark table view data source - implemented here

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionControllers count];
}

#pragma mark -
#pragma mark table view data source - required

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.sectionControllers objectAtIndex:section] tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.sectionControllers objectAtIndex:indexPath.section] tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark table view data source - optional

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.sectionControllers objectAtIndex:section] tableView:tableView titleForHeaderInSection:section];
}
//default nil
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	CDLTableSectionController *sectionController = [self.sectionControllers objectAtIndex:section];
	
	if ([sectionController respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
		return [sectionController tableView:tableView titleForFooterInSection:section];
	} else {
		return nil;
	}
}

#pragma mark editing
//default YES
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	CDLTableSectionController *sectionController = [self.sectionControllers objectAtIndex:indexPath.section];
	
	if ([sectionController respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
		return [sectionController tableView:tableView canEditRowAtIndexPath:indexPath];
	} else {
		return YES;
	}
}

#pragma mark moving/reordering
//default YES if there is an implementation of tableView:moveRowAtIndexPath:toIndexPath: in section controller, otherwise no
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	CDLTableSectionController *sectionController = [self.sectionControllers objectAtIndex:indexPath.section];
	
	if ([sectionController respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
		return [sectionController tableView:tableView canMoveRowAtIndexPath:indexPath];
	} else if ([sectionController respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
		return YES;
	} else {
		return NO;
	}
}

#pragma mark data manipulation - insert and delete support
//default nothing
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	CDLTableSectionController *sectionController = [self.sectionControllers objectAtIndex:indexPath.section];
	
	if ([sectionController respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
		return [sectionController tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
	} else {
		return;
	}
}

#pragma mark  data manipulation - reorder / moving support
//default nothing
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	CDLTableSectionController *sectionController = [self.sectionControllers objectAtIndex:fromIndexPath.section];
	
	if ([sectionController respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
		return [sectionController tableView:tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
	} else {
		return;
	}
}

#pragma mark -
#pragma mark table view delegate 

#pragma mark display customization
//default nothing
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	CDLTableSectionController *sectionController = [self.sectionControllers objectAtIndex:indexPath.section];
	
	if ([sectionController respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
		return [sectionController tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
	} else {
		return;
	}
}

#pragma mark variable height support
/** Default is to return tableView.rowHeight */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.sectionControllers objectAtIndex:indexPath.section] tableView:tableView heightForRowAtIndexPath:indexPath];
}
//default is tableVIew.sectionHeaderHeight
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	CDLTableSectionController *sectionController = [self.sectionControllers objectAtIndex:section];
//	
//	if ([sectionController respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
//		return [sectionController tableView:tableView heightForHeaderInSection:section];
//	} else {
//		CGFloat test = tableView.sectionHeaderHeight;
//		return test;
//	}
//}
//default is tableVIew.sectionFooterHeight
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//	CDLTableSectionController *sectionController = [self.sectionControllers objectAtIndex:section];
//	
//	if ([sectionController respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
//		return [sectionController tableView:tableView heightForFooterInSection:section];
//	} else {
//		return tableView.sectionFooterHeight;
//	}
//}

#pragma mark header/footer views

//ehh

#pragma mark selection
/** Default is to return indexPath if tableView.editing is true, otherwise, return nil. */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	CDLTableSectionController *sectionController = [self.sectionControllers objectAtIndex:indexPath.section];
	
	if ([sectionController respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
		return [sectionController tableView:tableView willSelectRowAtIndexPath:indexPath];
	} else if (tableView.editing) {
		return indexPath;
	} else {
		return nil;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.sectionControllers objectAtIndex:indexPath.section] tableView:tableView didSelectRowAtIndexPath:indexPath];
}


#pragma mark editing rows
/** Default is to return UITableViewCellEditingStyleNone */

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CDLTableSectionController *sectionController = [self.sectionControllers objectAtIndex:indexPath.section];
	
	if ([sectionController respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
		return [sectionController tableView:tableView editingStyleForRowAtIndexPath:indexPath];
	} else {
		return UITableViewCellEditingStyleNone;
	}
}
/** Default is to return NO */

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	CDLTableSectionController *sectionController = [self.sectionControllers objectAtIndex:indexPath.section];
	
	if ([sectionController respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]) {
		return [sectionController tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
	} else {
		return NO;
	}
}

#pragma mark moving rows


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	CDLTableSectionController *sectionController = [self.sectionControllers objectAtIndex:sourceIndexPath.section];
	
	if ([sectionController respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
		return [sectionController tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
	} else {
		return proposedDestinationIndexPath;
	}
}

@end
