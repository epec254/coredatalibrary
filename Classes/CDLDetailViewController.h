//
//  CDLRootViewController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the BSD License
//
//  code.google.com/p/coredatalibrary

#import "CDLTableSectionController.h"

@interface CDLDetailViewController : UITableViewController <CDLTableSectionControllerDelegate, UITableViewDelegate, UITableViewDataSource> {

@private
	NSManagedObject									*_managedObject;
	NSArray											*_sectionControllers;
    
}

/**
 NSManagedObject this detailViewController is handling.
 */
@property (nonatomic, retain)	NSManagedObject		*managedObject;
/**
 NSArray of the sectionControllers for the tableView (1 per tableView section)
 */
@property (nonatomic, copy)		NSArray				*sectionControllers;

/**
 Initializer for a CDLDetaiLView
 @param fullPathToPropertyListFile Full path to the plist file describing the tableView
 @param managedObject the NSManagedObject this controller will handle
 */
- (id) initForPropertyList:(NSString *) fullPathToPropertyListFile managedObject:(NSManagedObject *)managedObject;

@end
