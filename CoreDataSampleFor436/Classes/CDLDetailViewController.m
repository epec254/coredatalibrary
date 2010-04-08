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

- (Class) classOfManagedObject
{
	return [self.managedObject class];
}

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
	for (id<CDLTableSectionControllerProtocol> sectionController in self.sectionControllers) {
		[sectionController setEditing:editing animated:animated];
	}
	
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionControllers count];
}

#pragma mark -
#pragma mark SectionControllerProtocol Methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.sectionControllers objectAtIndex:section] tableView:tableView titleForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.sectionControllers objectAtIndex:section] tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.sectionControllers objectAtIndex:indexPath.section] tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark height


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	return [[self.sectionControllers objectAtIndex:indexPath.section] tableView:tableView heightForRowAtIndexPath:indexPath];
}
#pragma mark selecting rows
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.sectionControllers objectAtIndex:indexPath.section] tableView:tableView willSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.sectionControllers objectAtIndex:indexPath.section] tableView:tableView didSelectRowAtIndexPath:indexPath];
}


#pragma mark editing rows
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.sectionControllers objectAtIndex:indexPath.section] tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.sectionControllers objectAtIndex:indexPath.section] tableView:tableView editingStyleForRowAtIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.sectionControllers objectAtIndex:indexPath.section] tableView:tableView canEditRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.sectionControllers objectAtIndex:indexPath.section] tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

#pragma mark moving rows
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.sectionControllers objectAtIndex:indexPath.section] tableView:tableView canMoveRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	return [[self.sectionControllers objectAtIndex:fromIndexPath.section] tableView:tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
}
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	id<CDLTableSectionControllerProtocol> sectionController = [self.sectionControllers objectAtIndex:sourceIndexPath.section];
	if ([sectionController respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
		return [sectionController tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
	} else {
		return proposedDestinationIndexPath;
	}
}

@end
