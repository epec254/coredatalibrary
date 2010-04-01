//
//  ManagedObjectDetailViewSectionController.h
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLTableRowController.h"

@protocol CDLTableSectionController

//return number of rows in this section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//Return the title for this section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
//Pass along to the RowControllers
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//Pass along to the RowControllers
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//Pass along to the RowControllers
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//Pass along to the RowControllers
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;
//Pass along to the RowControllers
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
//Pass along to the RowControllers
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
//Pass along to the RowControllers
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
//Pass along to the RowControllers
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
//Pass along to the RowControllers
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
//Pass along to the RowControllers
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@optional
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;

@end


@protocol CDLTableSectionControllerDelegate;

@interface CDLTableSectionController : NSObject <CDLTableSectionController, CDLTableRowControllerDelegate> {
	
@protected
	BOOL	_inAddMode;

@private
	NSString *_sectionTitle;
	NSArray *_rowControllers;	
	id<CDLTableSectionControllerDelegate> _delegate;
}

@property (nonatomic, assign, setter=setInAddMode) BOOL inAddMode;
@property (nonatomic, copy) NSString *sectionTitle;
@property (nonatomic, copy) NSArray *rowControllers;
@property (nonatomic, assign) id<CDLTableSectionControllerDelegate> delegate;

+ (CDLTableSectionController *) tableSectionControllerForDictionary:(NSDictionary *) sectionInformation forDelegate:(id<CDLTableSectionControllerDelegate>) delegate;

- (id<CDLTableRowControllerProtocol>) rowControllersForRow:(NSInteger) row;
@end

@protocol CDLTableSectionControllerDelegate

- (Class) classOfManagedObject;
- (NSManagedObject *) managedObjectForSectionController:(CDLTableSectionController *)sectionController;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void) reloadSectionController:(CDLTableSectionController *) sectionController withRowAnimation:(UITableViewRowAnimation) rowAnimation;
@end

