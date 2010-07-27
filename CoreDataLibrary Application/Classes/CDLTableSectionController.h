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

//@protocol CDLTableSectionControllerDelegate;

@class CDLDetailViewController;

@protocol CDLTableSectionControllerProtocol <NSObject>

//** init for the given information, called by the detailView controller indirectly through tableSectionControllerForDictionary class method */
- (id) initForDictionary:(NSDictionary *) sectionInformation forDetailView:(CDLDetailViewController *)owner;

/** weak reference to the detailview, should be saved in init method */
@property (nonatomic, assign) CDLDetailViewController *detailView;


@end


//@protocol CDLTableSectionControllerDelegate;

@interface CDLTableSectionController : NSObject <CDLTableSectionControllerProtocol, CDLFieldEditControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
	
@protected
	BOOL	_inAddMode;
	BOOL	_editing;

@private
	NSString *_sectionTitle;
	NSArray *_rowControllers;	
	CDLDetailViewController *_detailView;
}

/** Return an autoreleased TableSectionController for this sectionInformation */
+ (CDLTableSectionController *) tableSectionControllerForDictionary:(NSDictionary *) sectionInformation forDetailView:(CDLDetailViewController *) owner;



/** return whether this sectionController is being used to add a new object, rather than edit one */
@property (nonatomic, assign, setter=setInAddMode) BOOL inAddMode;

/** return whether the section is in edit mode */
@property (nonatomic, readonly, getter=isEditing) BOOL editing;

/** Title of the section to display in the tableView */
@property (nonatomic, copy) NSString *sectionTitle;

/** Array of the row controllers this section controller manages */
@property (nonatomic, copy) NSArray *rowControllers;



//Internally used callbacks from the row controller

//present the action sheet in either tabBar or the view, whichever is more appropiate
- (void) presentActionSheet:(UIActionSheet *) actionSheet;

//Use if you want the sectionController to tell others about the Object it manages
- (NSManagedObject *) managedObject;

//allow a row to push a view controller - should pass to DetailView
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;



//TableView information

//Information only from the section controller
/** return number of rows in this section */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

/** Return the title for this section */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;

//information that CAN be from the row controllers

/** Pass along to the RowControllers, required in protocol */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

//all below methods are optional





/** Pass along to the RowControllers */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/** Pass along to the RowControllers, optional */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

///** Pass along to the RowControllers */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//
///** Pass along to the RowControllers */
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//
///** Pass along to the RowControllers */
//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;
//
///** Pass along to the RowControllers */
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
//
///** Pass along to the RowControllers */
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
//
///** Pass along to the RowControllers */
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
//
///** Pass along to the RowControllers */
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
//
///** Pass along to the RowControllers */
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
//
///** default is to return proposedDestinationIndexPath */
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;


@end


//part of detailview now
//@protocol CDLTableSectionControllerDelegate
//
//- (NSManagedObject *) managedObjectForSectionController:(CDLTableSectionController *)sectionController;
//
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
//
//- (void)reloadSectionController:(CDLTableSectionController *) sectionController withRowAnimation:(UITableViewRowAnimation) rowAnimation;
//
//@property (nonatomic, readonly) UITableView *theTableView;
//
///** return the section of this section controller */
// - (NSInteger)sectionOfSectionController:(id<CDLTableSectionControllerProtocol>) sectionController;
//
///** present the given UIActionSheet.  Presents in tabbar controller if present, otherwise in view */
//- (void) presentActionSheet:(UIActionSheet *) actionSheet;
//
//@end

