//
//  CDLRootViewController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the BSD License
//
//  code.google.com/p/coredatalibrary

#import "CDLRootViewController.h"
#import "CDLDetailViewController.h"
#import "CDLAddViewController.h"
#import "CDLSectionBugFixProtocol.h"


#import "DataController.h"

@interface CDLRootViewController(PrivateMethods)

@end

@implementation CDLRootViewController

@synthesize detailViewPropertyListFile = _detailViewPropertyListFile;
@synthesize cellTextLabelKeyPath = _cellTextLabelKeyPath;
@synthesize cellDetailTextLabelKeyPath = _cellDetailTextLabelKeyPath;
@synthesize sectionIndexTitlesEnabled = _sectionIndexTitlesEnabled;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize sortKeyPaths = _sortKeyPaths;
@synthesize entityName = _entityName;
@synthesize controllerTitle = _controllerTitle;
@synthesize filterPredicate = _filterPredicate;
@synthesize sectionNameKeyPath = _sectionNameKeyPath;
@synthesize alphaSectionIndexTitles = _alphaSectionIndexTitles;							 

#pragma mark -
#pragma mark Initializer

- (id) initForListViewControllerStructure:(NSString *) fullPathToPropertyListFile
{
	if (self = [super initWithStyle:UITableViewStylePlain]) {

		NSDictionary *loadedStructure = [[NSDictionary alloc] initWithContentsOfFile:fullPathToPropertyListFile];
		
		//input validation errors
		NSMutableArray *inputValidationErrors = [[NSMutableArray alloc] init];
		
		//EntityName - NSString
		self.entityName = [loadedStructure valueForKey:@"entityName"];
		
		if (![CDLUtilityMethods isLoadedStringValid:self.entityName]) {
			[inputValidationErrors addObject:@"entityName can't be empty"];
		}
		
		//Controller Title - NSString.  If not set, don't give the controller a title and set to nil.
		self.controllerTitle = [loadedStructure valueForKey:@"controllerTitle"];
		
		if ([CDLUtilityMethods isLoadedStringValid:self.controllerTitle]) {
			self.navigationItem.title = self.controllerTitle;
		} else {
			self.controllerTitle == nil;
		}

		
		//sortKeyPaths - NSArray of at least one item
		//TODO: verify this key is actually in the entity
		self.sortKeyPaths = [loadedStructure valueForKey:@"sortKeyPaths"];
		
		if (self.sortKeyPaths == nil || [self.sortKeyPaths count] == 0) {
			[inputValidationErrors addObject:@"sortKeyPaths must have at least one member"];
		} else {
			//now, verify the items inside sortKeyPaths
			BOOL isValid = YES;
			for (id aSortKeyPath in self.sortKeyPaths) {
				if (![CDLUtilityMethods isLoadedStringValid:aSortKeyPath]) {
					isValid = NO;
				}
			}
			if (!isValid) {
				[inputValidationErrors addObject:@"One or more of sortKeyPaths aren't valid - must be non-zero length NSStrings"];
			}
		}

		
		//sectionNameKeyPath - NSString.  If not set, revert to nil so we know not to display section index titles.
		self.sectionNameKeyPath = [loadedStructure valueForKey:@"sectionNameKeyPath"];
		
		if (![CDLUtilityMethods isLoadedStringValid:self.sectionNameKeyPath]) {
			self.sectionNameKeyPath = nil;
		}
		
		//detailViewPropertyListFile - NSString
		self.detailViewPropertyListFile = [loadedStructure valueForKey:@"detailViewPropertyListFile"];
		
		if (![CDLUtilityMethods isLoadedStringValid:self.detailViewPropertyListFile]) {
			[inputValidationErrors addObject:@"detailViewPropertyListFile can't be empty"];
		}
		
		//cellTextLabelKeyPath - NSString
		self.cellTextLabelKeyPath = [loadedStructure valueForKey:@"cellTextLabelKeyPath"];
		
		if (![CDLUtilityMethods isLoadedStringValid:self.cellTextLabelKeyPath]) {
			[inputValidationErrors addObject:@"cellTextLabelKeyPath can't be empty"];
		}
		
		//cellDetailTextLabelKeyPath - NSString.  If not set, revert to nil so we don't try to display a detail label.
		self.cellDetailTextLabelKeyPath = [loadedStructure valueForKey:@"cellDetailTextLabelKeyPath"];
		
		if (![CDLUtilityMethods isLoadedStringValid:self.cellDetailTextLabelKeyPath]) {
			self.cellDetailTextLabelKeyPath = nil;
		}
		
		if (self.sectionNameKeyPath != nil) { //only worry about section index titles if we have sections
			self.sectionIndexTitlesEnabled = [[loadedStructure valueForKey:@"sectionIndexTitlesEnabled"] boolValue]; //If this value isn't set in the plist, will revert to NO.
			
			if (self.sectionIndexTitlesEnabled && ([[loadedStructure valueForKey:@"sectionIndexTitlesAlphabetical"] boolValue] == YES)) {
				//if alpha titles are set, make the array of them to display
				self.alphaSectionIndexTitles = [[NSArray alloc] initWithObjects: @"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
			} else {
				//otherwise, set alphaSectionIndexTitles so we know to use the fetchedresultscontroller's titles later on
				self.alphaSectionIndexTitles = nil;
			}
		} else {
			//revert everything to nil
			self.sectionIndexTitlesEnabled = NO;
			self.alphaSectionIndexTitles = nil;
		}
		
		//create a tab bar item if wanted one
//		if ([[loadedStructure valueForKey:@"createTabBarItem"] boolValue] == YES) {
//		
//			NSString *imageName = [loadedStructure valueForKey:@"tabBarImage"];
//			NSString *tabBarTitle = [loadedStructure valueForKey:@"tabBarTitle"];
//			
//			if (![CDLUtilityMethods isLoadedStringValid:tabBarTitle] && self.controllerTitle == nil) {
//				//if they don't give us a title for the tab bar or a controller title, we can't create the tab bar item
//				[inputValidationErrors addObject:@"If creating a tabBarItem, you need to set either tabBarTitle OR controllerTitle"];
//			} else {
//				UITabBarItem* theItem = nil;
//				if ([CDLUtilityMethods isLoadedStringValid:imageName]) { //use specified image
//					theItem = [[UITabBarItem alloc] initWithTitle:self.controllerTitle image:[UIImage imageNamed:imageName] tag:0];
//				} else { //no image specified, don't display one
//					theItem = [[UITabBarItem alloc] initWithTitle:self.controllerTitle image:nil tag:0];
//				}
//				self.navigationController.tabBarItem = theItem;
//				[theItem release];
//			}			
//		}
		
		//Raise validation errors
		if ([inputValidationErrors count] > 0) {
			NSException *ex = [NSException exceptionWithName:@"Invalid input for CDLRootViewController" reason:[inputValidationErrors description] userInfo:nil];
			[ex raise];
		}
		
		[inputValidationErrors release];

		//TODO: finish filter predicate
		self.filterPredicate = nil;
		
		[loadedStructure release];
		
		_fullyLoaded = YES;
		
		self.tableView.sectionIndexMinimumDisplayRowCount = 6;
		
		
	}
	
	return self;
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//show the edit button
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	//show the add button
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
	self.navigationItem.rightBarButtonItem = addButtonItem;
	[addButtonItem release];
		
	if (_fullyLoaded) { //only try to load the objects if we have loaded from a plist
		NSError *error;
		//get the intial results back from the fetchedresultscontroller
		if (![[self fetchedResultsController] performFetch:&error]) {
			[[DataController sharedDataController] handleError:error fromSource:@"CDLRootViewController - viewDidLoad - performFetch"];
		}
	}
	
}

#pragma mark -
#pragma mark Adding content
- (void)add:(id)sender {

	//Create a new NSManagedObject to add
	NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:[[DataController sharedDataController] managedObjectContext]];
	
	//Create the AddViewController
	CDLAddViewController *addViewController = [[CDLAddViewController alloc] initForPropertyList:[[NSBundle mainBundle] pathForResource:self.detailViewPropertyListFile ofType:@"plist"] managedObject:newObject];
	
	UINavigationController *addNavigationController = [[UINavigationController alloc] initWithRootViewController:addViewController];
	
	[self.navigationController presentModalViewController:addNavigationController animated:YES];
	
	[addViewController release];
	[addNavigationController release];
	// [self presentModalViewController:navigationController animated:YES];
    

}

//- (void) genericAddViewController:(GenericAddViewController *)addViewController didAddManagedObject:(NSManagedObject *)newObject
//{
//	// Dismiss the modal add client view controller
//    [self dismissModalViewControllerAnimated:NO];
//	
//	if (newObject) {        
//		
//		AbstractDetailViewController *detailViewController = [AbstractDetailViewController detailViewControllerForEntityName:entityName withEntityObject:newObject friendlyName: controllerTitle];
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
	CDLDetailViewController *viewVC = [[CDLDetailViewController alloc] initForPropertyList:[[NSBundle mainBundle] pathForResource:self.detailViewPropertyListFile ofType:@"plist"] managedObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
	
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
		[[DataController sharedDataController] saveFromSource:[NSString stringWithFormat:@"commit delete at list table for %@", self.controllerTitle]];
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
		
	if (self.sectionNameKeyPath != nil && self.sectionIndexTitlesEnabled) {
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
	//NSString *cacheName = [[NSString alloc] initWithFormat:@"Root-%@", _entityName];
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[DataController sharedDataController] managedObjectContext] sectionNameKeyPath:self.sectionNameKeyPath cacheName:self.entityName];
	
	//[cacheName release];
	
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
		if (self.sectionNameKeyPath != nil) {
			NSException *ex = [NSException exceptionWithName:@"ManagedObjects must implement CDLSectionBugFixProtocol if you use a sectionNameKeyPath" reason:NSLocalizedString(@"CDLSectionBugFixProtocol not implemented", @"CDLSectionBugFixProtocol not implemented") userInfo:nil];
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
			
			if (newIndexPath != nil) {
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
			} else {
				[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationFade];
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
	
	[_controllerTitle release];
	_controllerTitle = nil;

	[_sortKeyPaths release];
	_sortKeyPaths = nil;
	
	[_filterPredicate release];
	_filterPredicate = nil;
	
	[_sectionNameKeyPath release];
	_sectionNameKeyPath = nil;
	
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

