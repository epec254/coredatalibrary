//
//  AbstractModificationViewController.h
//
// Created by Eric Peter for Wash U CSE 436
// Changed to allow easy use with Core Data
// heavily modified from original code by:
//  Created by Jeff LaMarche on 2/18/09.


@protocol CDLFieldEditControllerDelegate;

@interface CDLAbstractFieldEditController : UITableViewController 
{	
@protected
	BOOL								_inAddMode;
	
@private
	NSManagedObject						*_managedObject;		// NSManagedObject we are editing
	NSArray								*_attributeLabels;		// Field name(s) to be displayed to user
	NSArray								*_attributeKeyPaths;	// Key value coding(s) of the entity attributes we are editing
	NSMutableArray						*_keyboardTypes;		// keyboard types for each field
	NSInteger							_maximumFields;		// Maximum number of fields supported for editing in this view
	id<CDLFieldEditControllerDelegate>	_delegate;
}

@property (nonatomic, assign, setter=setInAddMode) BOOL inAddMode;

// cancel the changes
- (void) cancel;

//put the values from the fields into the ManagedObject with setValue ForKey
- (void) updateObjectWithValues;

//Validate the ManagedObject and if valid, pop the view controller.  Otherwise, alert the user.
- (void) validateAndPop;

// init
- (id) initWithMaximumFields:(NSInteger) maximum forManagedObject:(NSManagedObject *)managedObject;

// properties
@property (nonatomic, retain) NSManagedObject *managedObject;
@property (nonatomic, copy) NSArray *attributeLabels;
@property (nonatomic, copy) NSArray *attributeKeyPaths;
@property (nonatomic, retain) NSMutableArray *keyboardTypes;
@property (nonatomic, assign) NSInteger maximumFields;

@property (nonatomic, readonly) BOOL isNumberProperty; //Does the attributeKeyPath represent a NSNumber
@property (nonatomic, readonly) NSString *attributeStringValue;
@property (nonatomic, readonly) id attributeObjectValue;
@property (nonatomic, assign) id<CDLFieldEditControllerDelegate> delegate;

- (NSString *) stringValueForObject:(id) anObject;

@end

@protocol CDLFieldEditControllerDelegate
- (void) fieldEditController:(CDLAbstractFieldEditController *) controller didEndEditing: (BOOL) wasCancelled;
@end