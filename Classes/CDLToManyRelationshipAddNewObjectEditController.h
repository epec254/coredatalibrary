//
//  CDLToManyRelationshipAddNewObjectController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import "CDLAddViewController.h"
#import "CDLAbstractFieldEditController.h"
@interface CDLToManyRelationshipAddNewObjectEditController : CDLAddViewController {
	NSString *_relationshipEntityName;
	NSString *_label;
		NSString *_keyForRelationship;
	NSManagedObject *_editingObject;
	NSManagedObject *_newObject;
	
	id<CDLFieldEditControllerDelegate>	_delegate;

}

/** the key to the toMany relationship in editingObject */
@property (nonatomic, copy) NSString *keyForRelationship;


/** the new object we are creating */
@property (nonatomic, retain) NSManagedObject *newObject;

/** NSManagedObject we are creating this new object to relate to */
@property (nonatomic, retain) NSManagedObject *editingObject;
/** name of the related Entity we are creating */
@property (nonatomic, copy) NSString *relationshipEntityName;
/** rowLabel - title to display */
@property (nonatomic, copy) NSString *label;

@property (nonatomic, assign) id<CDLFieldEditControllerDelegate> delegate;

- (id) initForPropertyList:(NSString *) fullPathToPropertyListFile editingObject:(NSManagedObject *)editingObject relationshipEntityName:(NSString *) relationshipEntityName relationshipKey:(NSString *) relationshipKey label:(NSString *) label;
@end
