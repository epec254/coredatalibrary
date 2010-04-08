//
//  CDLToManyOrderedRelationshipAddTableRowController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary


@class CDLToManyOrderedRelationshipSectionController;
#import "CDLToManyOrderedRelationshipTableRowController.h"

@interface CDLToManyOrderedRelationshipAddTableRowController : CDLToManyOrderedRelationshipTableRowController {
@private
	CDLToManyOrderedRelationshipSectionController *_sectionController;
}

/** weak reference to owning section controller */
@property (nonatomic, assign) CDLToManyOrderedRelationshipSectionController *sectionController;

/** Name of entity used to store the ordered relationship */
@property (nonatomic, readonly) NSString *relationshipIntermediateEntityName;
/** Name of entities at the end of the relationship */
@property (nonatomic, readonly) NSString *relationshipEntityName;

@end
