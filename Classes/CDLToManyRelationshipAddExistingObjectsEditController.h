//
//  CDLToManyRelationshipEditController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary
//
#import "CDLToOneRelationshipEditController.h"


@interface CDLToManyRelationshipAddExistingObjectsEditController : CDLToOneRelationshipEditController {
@private
		NSMutableSet		*_selectedObjects;
}
/** Set of all selected objects */
@property (nonatomic, retain) NSMutableSet *selectedObjects;

- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath forChoicesEntity:(NSString *)choicesEntityName;


@end
