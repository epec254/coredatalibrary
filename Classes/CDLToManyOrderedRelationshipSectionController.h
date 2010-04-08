//
//  CDLToManyOrderedRelationshipSectionController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import "CDLAbstractFieldEditController.h"
#import "CDLToManyRelationshipSectionController.h"

@class CDLToManyOrderedRelationshipAddTableRowController;

@interface CDLToManyOrderedRelationshipSectionController : CDLToManyRelationshipSectionController <CDLFieldEditControllerDelegate> {
@private	
	NSString *_relationshipIntermediateEntityName;
}



/** Name of entity used to store the ordered relationship */
@property (nonatomic, copy) NSString *relationshipIntermediateEntityName;


@end

