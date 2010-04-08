//
//  CDLTableSectionController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary


#import "CDLTableRowController.h"
#import "CDLAbstractFieldEditController.h"

@protocol CDLTableSectionControllerProtocol <NSObject>

/** return number of rows in this section */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

/** Return the title for this section */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;

/** Pass along to the RowControllers */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/** Pass along to the RowControllers */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/** Pass along to the RowControllers */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

/** Pass along to the RowControllers */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/** Pass along to the RowControllers */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/** Pass along to the RowControllers */
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;

/** Pass along to the RowControllers */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;

/** Pass along to the RowControllers */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

/** Pass along to the RowControllers */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

/** Pass along to the RowControllers */
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

/** Pass along to the RowControllers */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@optional
/** default is to return proposedDestinationIndexPath */
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;

@end


@protocol CDLTableSectionControllerDelegate;

@interface CDLTableSectionController : NSObject <CDLTableSectionControllerProtocol, CDLTableRowControllerDelegate, CDLFieldEditControllerDelegate> {
	
@protected
	BOOL	_inAddMode;

@private
	NSString *_sectionTitle;
	NSArray *_rowControllers;	
	id<CDLTableSectionControllerDelegate> _delegate;
}

/** return whether this sectionController is being used to add a new object, rather than edit one */
@property (nonatomic, assign, setter=setInAddMode) BOOL inAddMode;
/** Title of the section to display in the tableView */
@property (nonatomic, copy) NSString *sectionTitle;
/** Array of the row controllers this section controller manages */
@property (nonatomic, copy) NSArray *rowControllers;
/** delegate */
@property (nonatomic, assign) id<CDLTableSectionControllerDelegate> delegate;

/** Return an autoreleased TableSectionController for this sectionInformation */
+ (id<CDLTableSectionControllerProtocol>) tableSectionControllerForDictionary:(NSDictionary *) sectionInformation forDelegate:(id<CDLTableSectionControllerDelegate>) delegate;

@end

@protocol CDLTableSectionControllerDelegate

- (Class) classOfManagedObject;
- (NSManagedObject *) managedObjectForSectionController:(CDLTableSectionController *)sectionController;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)reloadSectionController:(CDLTableSectionController *) sectionController withRowAnimation:(UITableViewRowAnimation) rowAnimation;
@end

