//
//  CDLToOneRelationshipEditController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the BSD License
//
//  code.google.com/p/coredatalibrary
//
//  Original concept based on code by Jeff LaMarche (SuperDB) - http:// iphonedevelopment.blogspot.com

#import "CDLAbstractFieldEditController.h"

@interface CDLToOneRelationshipEditController : CDLAbstractFieldEditController 
{

@private
	NSArray				*_listOfChoices;
	
	UITableViewCell		*currentlySelectedCell;
	
	NSPredicate			*_choicesPredicate;	
	
	NSString			*_choicesEntityName; 
	
}
/** array of NS Managed Objects that are the choices */
@property (nonatomic, retain) NSArray *listOfChoices;

/** the name of the property of the NSManagedObjects in the listChoices to display to the user. */
@property (nonatomic, readonly) NSString *choicesDisplayPropertyKey;

/** name of the entity that we are choosing */
@property (nonatomic, copy) NSString *choicesEntityName;

/** pointer to the currently chosen table view cell (weak reference) */
@property (nonatomic, assign) UITableViewCell *currentlySelectedCell;

/** optional filter for choices */
@property (nonatomic, retain) NSPredicate *choicesPredicate;

/** the currently selected choice */
- (NSManagedObject *) selectedObjectAtRelationship;

/** first part of the key path - directly to the relationship (not the display property) */
- (NSString *) keyForRelationship;
@end

