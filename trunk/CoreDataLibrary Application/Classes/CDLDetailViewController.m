#import "CDLDetailViewController.h"
#import "CDLTableSectionController.h"

@implementation CDLDetailViewController

@synthesize sectionControllers = _sectionControllers;
@synthesize managedObject = _managedObject;

#pragma mark -
#pragma mark init

- (id) initForPropertyList:(NSString *) fullPathToPropertyListFile forManagedObject:(NSManagedObject *)managedObject
{
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.managedObject = managedObject;
		
		//load the plist and do a sanity check
		id loadedStructure = [[NSArray alloc] initWithContentsOfFile:fullPathToPropertyListFile];
		
		if (![loadedStructure isKindOfClass:[NSArray class]]) {
			NSException *ex = [NSException exceptionWithName:@"Loaded structure not valid" reason:NSLocalizedString(@"Base class is not an array", @"Base class is not an array") userInfo:nil];
			[ex raise];
		}
		
		NSMutableArray *theSectionControllers = [[NSMutableArray alloc] init];
		
		for (int i = 0; i < [loadedStructure count]; i++) //loop through each section 
		{
			id sectionInfo = [loadedStructure objectAtIndex:i];
			
			if (![sectionInfo isKindOfClass:[NSDictionary class]]) {
				NSException *ex = [NSException exceptionWithName:@"Loaded section info not valid" reason:NSLocalizedString(@"Base class is not a dictionary", @"Base class is not a dictionary") userInfo:nil];
				[ex raise];
			}
			
			CDLTableSectionController *aSectionController = [CDLTableSectionController tableSectionControllerForDictionary:sectionInfo forDelegate:self];
			//aSectionController.delegate = self;
			
			[theSectionControllers insertObject:aSectionController atIndex:i];
			
			//[aSectionController release];
		}
		
		self.sectionControllers = [NSArray arrayWithArray:theSectionControllers];
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
	[self.tableView reloadData];
	
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:rowAnimation];
}

#pragma mark -
#pragma mark original class

//
//- (IBAction)save {
//    NSError *error;
//    if (![self.managedObject.managedObjectContext save:&error])
//        NSLog(@"Error saving: %@", [error localizedDescription]);
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}
//- (IBAction)cancel {
//    if ([self.managedObject isNew])
//        [self.managedObject.managedObjectContext deleteObject:self.managedObject];
//    [self.navigationController popViewControllerAnimated:YES];
//}
//- (void)viewDidLoad {
//    self.tableView.editing = YES;
//    self.tableView.allowsSelectionDuringEditing = YES;
//    
//    [super viewDidLoad];
//}
- (void)viewWillAppear:(BOOL)animated {	
	
//    if (self.showSaveCancelButtons) {
//        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] 
//                                         initWithTitle:NSLocalizedString(@"Cancel", 
//                                                                         @"Cancel - for button to cancel changes")
//                                         style:UIBarButtonSystemItemCancel
//                                         target:self
//                                         action:@selector(cancel)];
//        self.navigationItem.leftBarButtonItem = cancelButton;
//        [cancelButton release];
//        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
//                                       initWithTitle:NSLocalizedString(@"Save", 
//                                                                       @"Save - for button to save changes")
//                                       style:UIBarButtonItemStyleDone
//                                       target:self 
//                                       action:@selector(save)];
//        self.navigationItem.rightBarButtonItem = saveButton;
//        [saveButton release];
//        
//    }
//    else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    }
    
    [super viewWillAppear:animated];
	
	[self.tableView reloadData];
}
- (void)dealloc {
    [_managedObject release];
	_managedObject = nil;
	

	
	[_sectionControllers release];
	_sectionControllers = nil;

    [super dealloc];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	self.navigationItem.hidesBackButton = editing;
	for (CDLTableSectionController *sectionController in self.sectionControllers) {
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
#pragma mark table view delegatd to section controllers

#pragma mark section info
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.sectionControllers objectAtIndex:section] tableView:tableView titleForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.sectionControllers objectAtIndex:section] tableView:tableView numberOfRowsInSection:section];
}
#pragma mark cell creation
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
	CDLTableSectionController *sectionController = [self.sectionControllers objectAtIndex:sourceIndexPath.section];
	if ([sectionController respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
		return [sectionController tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
	} else {
		return proposedDestinationIndexPath;
	}

												   
											
}

@end
