//
//  CDLRootViewController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
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


//TableView Stuff

//implemented here
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

//implemented in CDLTableSectionController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//will be passed along to sectionController if subclass implements it, otherwise default value

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section; //default nil

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath; //default YES

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath; //default YES if there is an implementation of tableView:moveRowAtIndexPath:toIndexPath: in section controller, otherwise no

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath; //default nothing

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath; //default nothing

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath; //default nothing

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; //Default is to return tableView.rowHeight

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath; //Default is to return indexPath if tableView.editing is true, otherwise, return nil.

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath; //Default is to return UITableViewCellEditingStyleNone

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath; //default NO

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath; //default return proposedDestinationIndexPath

@end
