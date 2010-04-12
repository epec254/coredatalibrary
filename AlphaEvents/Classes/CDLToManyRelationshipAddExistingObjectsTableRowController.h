//
//  CDLToManyRelationshipAddTableRowController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary
//

#import "CDLToManyRelationshipTableRowController.h"
@class CDLToManyRelationshipSectionController;

@interface CDLToManyRelationshipAddExistingObjectsTableRowController : CDLToManyRelationshipTableRowController {
@private
	CDLToManyRelationshipSectionController *_sectionController;
}

@property (nonatomic, assign) CDLToManyRelationshipSectionController *sectionController;

/** Name of entities at the end of the relationship */
@property (nonatomic, readonly) NSString *relationshipEntityName;
@end
