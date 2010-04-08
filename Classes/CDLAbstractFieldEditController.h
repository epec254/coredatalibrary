//
//  CDLAbstractFieldEditController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary
//
//  Original concept based on code by Jeff LaMarche (SuperDB) - http:// iphonedevelopment.blogspot.com


@protocol CDLFieldEditControllerDelegate;

@interface CDLAbstractFieldEditController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{	
@protected
	BOOL								_inAddMode;
	
@private
	NSManagedObject						*_managedObject;		
	NSString							*_attributeLabel;
	NSString							*_attributeKeyPath;
	UIKeyboardType						_attributeKeyboardType;
	
	id<CDLFieldEditControllerDelegate>	_delegate;
}
/** NSManagedObject we are editing an attribute in */
@property (nonatomic, retain) NSManagedObject *managedObject;

/** Attribute name (label) to be displayed to user */
@property (nonatomic, copy) NSString *attributeLabel;

/** Key value coding path of the attribute we are editing*/
@property (nonatomic, copy) NSString *attributeKeyPath;

/** Keyboard type for the attribute*/
@property (nonatomic, assign) UIKeyboardType attributeKeyboardType;

/** Is this edit controller being used to modify properties of a newly created object? */
@property (nonatomic, assign, setter=setInAddMode) BOOL inAddMode;

/** NSString value of the attribute */
@property (nonatomic, readonly) NSString *attributeStringValue;

/** Return the attribute value unmodified */
@property (nonatomic, readonly) id attributeObjectValue;

/* Cancel changes and pop from stack */
- (void) cancel;

/** Update the NSManagedObject with entered data using setValue ForKey */
- (void) updateObjectWithValues;

/** Validate the ManagedObject and if valid, pop the view controller.  Otherwise, alert the user. */
- (void) validateSaveAndPop;

/** standard init */
- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath  ;

/** the delegate */
@property (nonatomic, assign) id<CDLFieldEditControllerDelegate> delegate;

@end

@protocol CDLFieldEditControllerDelegate <NSObject>
- (void) fieldEditController:(CDLAbstractFieldEditController *) controller didEndEditingCanceled: (BOOL) wasCancelled;
@end