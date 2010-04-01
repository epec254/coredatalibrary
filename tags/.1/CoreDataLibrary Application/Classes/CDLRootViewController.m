//
//  AbstractMainViewController.m
//  BEPersonalTrainingManager
//
//  Created by Eric Peter on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CDLRootViewController.h"
#import "CDLDetailViewController.h"

#import "DataController.h"
#import "CDLAddViewController.h"
#import "CDLSectionBugFixProtocol.h"

static const NSInteger minimumRowsForSectionIndexTitles = 9;

@implementation CDLRootViewController

@synthesize detailViewPropertyListFile = _detailViewPropertyListFile;
@synthesize cellTextLabelKeyPath = _cellTextLabelKeyPath;
@synthesize cellDetailTextLabelKeyPath = _cellDetailTextLabelKeyPath;
@synthesize sectionIndexTitlesEnabled = _sectionIndexTitlesEnabled;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize sortKeyPaths = _sortKeyPaths;
@synthesize entityName = _entityName;
@synthesize entityFriendlyName = _entityFriendlyName;
@synthesize filterPredicate = _filterPredicate;
@synthesize sectionKeyPath = _sectionKeyPath;
@synthesize alphaSectionIndexTitles = _alphaSectionIndexTitles;

#pragma mark -
#pragma mark Initializer

- (id) initWithStyle: (UITableViewStyle) style
{
	if (self = [super initWithStyle:style]) {
		self.tableView.sectionIndexMinimumDisplayRowCount = minimumRowsForSectionIndexTitles;
		_fullyLoaded = NO;
		
		self.cellDetailTextLabelKeyPath = nil;
		self.sectionKeyPath = nil;
		self.sectionIndexTitlesEnabled = NO;
		self.alphaSectionIndexTitles = nil;
		self.filterPredicate = nil;

	}
	
	return self;
}

- (id) initForListViewControllerStructure:(NSString *) fullPathToPropertyListFile
{
	if (self = [super initWithStyle:UITableViewStylePlain]) {
		NSDictionary *loadedStructure = [[NSDictionary alloc] initWithContentsOfFile:fullPathToPropertyListFile];
		
		self.entityName = [loadedStructure valueForKey:@"entityName"];
		self.entityFriendlyName = [loadedStructure valueForKey:@"entityFriendlyName"];
		self.sortKeyPaths = [loadedStructure valueForKey:@"sortKeyPaths"];
		self.sectionKeyPath = [loadedStructure valueForKey:@"sectionKeyPath"];
		
		self.detailViewPropertyListFile = [loadedStructure valueForKey:@"detailViewPropertyListFile"];
		
		self.cellTextLabelKeyPath = [loadedStructure valueForKey:@"cellTextLabelKeyPath"];
		self.cellDetailTextLabelKeyPath = [loadedStructure valueForKey:@"cellDetailTextLabelKeyPath"];
		
		self.sectionIndexTitlesEnabled = [[loadedStructure valueForKey:@"sectionIndexTitlesEnabled"] boolValue];
		
		if (self.sectionIndexTitlesEnabled && ([[loadedStructure valueForKey:@"sectionIndexTitlesAlphabetical"] boolValue] == YES)) {
			self.alphaSectionIndexTitles = [[NSArray alloc] initWithObjects: @"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
		} else {
			self.alphaSectionIndexTitles = nil;
		}
		
		if (self.entityName == nil || self.entityFriendlyName == nil || self.sortKeyPaths == nil || self.detailViewPropertyListFile == nil || self.cellTextLabelKeyPath == nil) {
			NSException *ex = [NSException exceptionWithName:@"Loaded structure not valid" reason:NSLocalizedString(@"Missing property", @"Missing property") userInfo:nil];
			[ex raise];
		}

		//TODO: finish filter predicate
		self.filterPredicate = nil;
		
		self.navigationItem.title = self.entityFriendlyName;
		
		
		//create a tab bar item if wanted
		//Image support can be easily added
		if ([[loadedStructure valueForKey:@"createTabBarItem"] boolValue] == YES) {
			UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:self.entityFriendlyName image:nil tag:0];
			self.tabBarItem = theItem;
			[theItem release];
		}
		

		[loadedStructure release];
		_fullyLoaded = YES;
	}
	
	return self;
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	if (_fullyLoaded) { //only do this if we are loading from a plist file - the other initalizer will set this to NO
		//show the edit button
		self.navigationItem.leftBarButtonItem = self.editButtonItem;
		
		//show the add button
		UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
		self.navigationItem.rightBarButtonItem = addButtonItem;
		[addButtonItem release];
//TODO: adding
		
		//get the intial results back from the fetchedresultscontroller
	
		NSError *error;
		if (![[self fetchedResultsController] performFetch:&error]) {
			[[DataController sharedDataController] handleError:error fromSource:@"view did load - fetch request"];
		}
	}
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {

	[super viewDidUnload];
}



#pragma mark -
#pragma mark Adding content
//TODO: add support
- (void)add:(id)sender {

	
	NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:[[DataController sharedDataController] managedObjectContext]];
	
	CDLAddViewController *addViewController = [[CDLAddViewController alloc] initForPropertyList:[[NSBundle mainBundle] pathForResource:self.detailViewPropertyListFile ofType:@"plist"] forManagedObject:newObject];
	[self.navigationController pushViewController:addViewController animated:YES];
	
	[addViewController release];
	// [self presentModalViewController:navigationController animated:YES];
    

}

//- (void) genericAddViewController:(GenericAddViewController *)addViewController didAddManagedObject:(NSManagedObject *)newObject
//{
//	// Dismiss the modal add client view controller
//    [self dismissModalViewControllerAnimated:NO];
//	
//	if (newObject) {        
//		
//		AbstractDetailViewController *detailViewController = [AbstractDetailViewController detailViewControllerForEntityName:entityName withEntityObject:newObject friendlyName: entityFriendlyName];
//		detailViewController.didComeFromAddViewController = YES;
//		[self.navigationController pushViewController:detailViewController animated:YES];
//		//[detailViewController setEditing:YES animated:YES];
//    }
//    

	
//}


#pragma mark -
#pragma mark table view rows/section 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSUInteger count = [[self.fetchedResultsController sections] count];

    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *sections = [self.fetchedResultsController sections];
    NSUInteger count = 0;
    if ([sections count]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        count = [sectionInfo numberOfObjects];
    }
    return count;}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

#pragma mark -
#pragma mark table view cells

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ListViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
		UITableViewCellStyle style = UITableViewCellStyleDefault;
		if (self.cellDetailTextLabelKeyPath != nil)
		{
			style = UITableViewCellStyleSubtitle;
		}
		
        cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.editingAccessoryType = UITableViewCellAccessoryNone;
    }
    
	[self configureCell:cell atIndexPath:indexPath];	
	
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	NSManagedObject *objectAtIndex = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	//If we don't have a string as the keyPath, use the string returned by description to avoid a crash.
	
	id textLabelObject = [objectAtIndex valueForKeyPath:self.cellTextLabelKeyPath];
	
	if ([textLabelObject isKindOfClass:[NSString class]]) {
		cell.textLabel.text = textLabelObject;
	} else {
		cell.textLabel.text = [textLabelObject description];
	}

	
	if (self.cellDetailTextLabelKeyPath != nil) {
		
		id detailTextLabelObject = [objectAtIndex valueForKeyPath:self.cellDetailTextLabelKeyPath];
		
		if ([detailTextLabelObject isKindOfClass:[NSString class]]) {
			cell.detailTextLabel.text = detailTextLabelObject;
		} else {
			cell.detailTextLabel.text = [detailTextLabelObject description];
		}
		
	}
}

#pragma mark -
#pragma mark table view row selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//show detail view
	CDLDetailViewController *viewVC = [[CDLDetailViewController alloc] initForPropertyList:[[NSBundle mainBundle] pathForResource:self.detailViewPropertyListFile ofType:@"plist"] forManagedObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
	[self.navigationController pushViewController:viewVC animated:YES];
	[viewVC release];
}

#pragma mark -
#pragma mark table view row editing/moving

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
		[MANAGED_OBJECT_CONTEXT deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
		//save the context
		[[DataController sharedDataController] saveFromSource:[NSString stringWithFormat:@"commit delete at list table for %@", self.entityFriendlyName]];
	}   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark -
#pragma mark table view section index titles

/**
 These will be hidden automatically by the tableview under the minimum number of rows
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
		
	if (self.sectionIndexTitlesEnabled) {
		if (self.alphaSectionIndexTitles != nil) { //return the alpha index titles
			return self.alphaSectionIndexTitles;
		} else {
			return [self.fetchedResultsController sectionIndexTitles]; //return the controller's generated index titles
		}
	} else {
		return nil; //no section index titles
	}

}

/**
 Create a mapping from index -> section, logic is only needed if we are using the alphabetical titles
 */
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	if (self.sectionIndexTitlesEnabled && self.alphaSectionIndexTitles == nil) { //using the FRC's index titles, pass along to the FRC.
		return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
	}
	
	//otherwise, we are using the alpha titles and need to make some magic happen for letters we don't have a section for.
	
	NSArray *frcSectionIndexTitles = [self.fetchedResultsController sectionIndexTitles];
	NSInteger indexForTitle = [frcSectionIndexTitles indexOfObject:title];
	
	if (indexForTitle != NSNotFound) { //section exists?  return that.
		return indexForTitle;
	}
	
	unichar titleCharacter = [title characterAtIndex:0];
	NSInteger belowResult = NSNotFound;
	unichar belowCharacter = 0;
	NSInteger aboveResult = NSNotFound;
	unichar aboveCharacter = 0;
	
	if (index <= 13) { //first half of alphabet
		for (unichar c = titleCharacter + 1; c <= 'L'; c++) { //search from next character to half way
			belowResult = [frcSectionIndexTitles indexOfObject:[NSString stringWithFormat:@"%c", c]];
			if (belowResult != NSNotFound) {
				belowCharacter = c;
				break;
			}
		}
		
		for (unichar c = titleCharacter - 1; c >= 'A'; c--) { //search from previous character to beginning
			aboveResult = [frcSectionIndexTitles indexOfObject:[NSString stringWithFormat:@"%c", c]];
			if (aboveResult != NSNotFound) {
				aboveCharacter = c;
				break;
			}
		}
		
		if (aboveResult == NSNotFound && belowResult == NSNotFound) { //default to the top
			indexForTitle = 0;
		}
	} else { //second half of alphabet
		for (unichar c = titleCharacter + 1; c <= 'Z'; c++) { //search from next character to half way
			belowResult = [frcSectionIndexTitles indexOfObject:[NSString stringWithFormat:@"%c", c]];
			if (belowResult != NSNotFound) {
				belowCharacter = c;
				break;
			}
		}
		
		for (unichar c = titleCharacter - 1; c >= 'M'; c--) { //search from previous character to beginning
			aboveResult = [frcSectionIndexTitles indexOfObject:[NSString stringWithFormat:@"%c", c]];
			if (aboveResult != NSNotFound) {
				aboveCharacter = c;
				break;
			}
		}	
		
		if (aboveResult == NSNotFound && belowResult == NSNotFound) { //default to last row in the sections, this will the lowest possible section
			indexForTitle = [frcSectionIndexTitles count] - 1;
		}
	}
	
	if (belowResult != NSNotFound && aboveResult != NSNotFound) { //found both, return whichever is closer
		indexForTitle = ((titleCharacter - aboveCharacter) < (belowCharacter - titleCharacter)) ? aboveResult : belowResult;
	} else if (belowResult != NSNotFound) {
		indexForTitle = belowResult;
	} else if (aboveResult != NSNotFound) {
		indexForTitle = aboveResult;
	} 
	


	return indexForTitle;

}

/**
 Reload the section Index titles if they are enabled
 */
- (void) reloadSectionIndexTitles
{
	if (self.sectionIndexTitlesEnabled)  {
		[self.tableView reloadData]; //reloadSectionIndexTitles sometimes doesn't work, so we use this
	}
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
	
	if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
	
	//what type of objects?
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:[[DataController sharedDataController] managedObjectContext]];
	[fetchRequest setEntity:entity];
	
	if (self.filterPredicate != nil) {
		[fetchRequest setPredicate:self.filterPredicate];
	}
	
	//how to sort?
	NSMutableArray *sortDescriptors = [NSMutableArray arrayWithCapacity:[self.sortKeyPaths count]];
	
	for (NSString *sortKey in self.sortKeyPaths) 
	{
		NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES selector:@selector(caseInsensitiveCompare:)];
		
		[sortDescriptors addObject:sort];
		[sort release];
	}

	[fetchRequest setSortDescriptors:sortDescriptors];
	
	//create the controller
	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[DataController sharedDataController] managedObjectContext] sectionNameKeyPath:self.sectionKeyPath cacheName:[NSString stringWithFormat:@"Root-%@", self.entityName]];
	aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	//memory cleanup
	[aFetchedResultsController release];
	[fetchRequest release];
	
	return _fetchedResultsController;
}

#pragma mark -
#pragma mark Fetched results controller delegate methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
	[self reloadSectionIndexTitles];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
		
	//fix from http:// developer.apple.com/iphone/library/releasenotes/iPhone/NSFetchedResultsChangeMoveReportedAsNSFetchedResultsChangeUpdate/index.html
	//requires coding in the NSManagedObject to work
	if ([anObject conformsToProtocol:@protocol(CDLSectionBugFixProtocol)]) {
		id<CDLSectionBugFixProtocol> anObjectWithBugFix = anObject;
		
		if ((NSFetchedResultsChangeUpdate == type) && ([anObjectWithBugFix changedSection]) ) {
			[anObjectWithBugFix setChangedSection:NO];
			type = NSFetchedResultsChangeMove;
			newIndexPath = indexPath;
		}
	} else {
		if (self.sectionKeyPath != nil) {
			NSException *ex = [NSException exceptionWithName:@"ManagedObjects must implement MOSectionBugFixProtocol if you use a sectionKeyPath" reason:[NSString stringWithFormat:@"MOSectionBugFixProtocol not implemented in entity %@ and sectionKeyPath set.", self.entityFriendlyName] userInfo:nil];
			[ex raise];
		}
	}

    
		
	switch(type) {
		case NSFetchedResultsChangeInsert:
			//insert a row into the appropiate section
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:(indexPath.row == 0 ? UITableViewRowAnimationFade : UITableViewRowAnimationTop)];
			break;
		case NSFetchedResultsChangeDelete:
			//insert a row into the appropiate section
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:(indexPath.row == 0 ? UITableViewRowAnimationFade : UITableViewRowAnimationTop)];
			break;
        case NSFetchedResultsChangeUpdate: 
			//refresh the cell, something other than the sorting order changed.
			[self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
		case NSFetchedResultsChangeMove:
			
			//credit to this code from https:// devforums.apple.com/message/117809#117809
			if([self.tableView numberOfRowsInSection:indexPath.section] == 1) {
				//we removed the last row of this section, delete it
				[self.tableView deleteSections :[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:(indexPath.section == 0 ? UITableViewRowAnimationFade : UITableViewRowAnimationTop)];
			}
			else {
				//otherwise, just remove this row (other rows remain in the section)
				[self.tableView deleteRowsAtIndexPaths :[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			}
			
			if([[[controller sections] objectAtIndex:newIndexPath.section] numberOfObjects] == 1) {
				//brand new section (we are the first row in it), so create it
				[self.tableView insertSections :[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:(newIndexPath.row == 0 ? UITableViewRowAnimationFade : UITableViewRowAnimationTop)];
							
			}
			else {
				//otherwise, just add a new row to the existing section
				[self.tableView insertRowsAtIndexPaths :[NSArray arrayWithObject:newIndexPath] withRowAnimation:(newIndexPath.row == 0 ? UITableViewRowAnimationFade : UITableViewRowAnimationTop)];
			}
			break;
        default:
			break;
	}
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		default:
            break;
	}
}

#pragma mark -
#pragma mark mem mgt

- (void)dealloc {
	
	[_fetchedResultsController release];
	_fetchedResultsController = nil;
	[_entityName release];
	_entityName = nil;
	[_entityFriendlyName release];
	_entityFriendlyName = nil;

	[_sortKeyPaths release];
	_sortKeyPaths = nil;
	[_filterPredicate release];
	_filterPredicate = nil;
	
	[_alphaSectionIndexTitles release];
	_alphaSectionIndexTitles = nil;

	[_cellTextLabelKeyPath release];
	_cellTextLabelKeyPath = nil;
	[_cellDetailTextLabelKeyPath release];
	_cellDetailTextLabelKeyPath = nil;

	[_detailViewPropertyListFile release];
	_detailViewPropertyListFile = nil;

    [super dealloc];
}


@end

