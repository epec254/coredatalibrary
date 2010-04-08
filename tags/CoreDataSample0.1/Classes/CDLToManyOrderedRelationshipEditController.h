//
//  CDLToManyOrderedRelationshipAddController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary
//

#import "CDLToManyRelationshipAddExistingObjectsEditController.h"


@interface CDLToManyOrderedRelationshipEditController : CDLToManyRelationshipAddExistingObjectsEditController
{
@private	
	NSString			*_choiceObjectAttributeNameInIntermediateEntity;
	NSString			*_intermediateEntityName;
}

/** the name of the relationship relating the editing object to the choices */
@property (nonatomic, copy) NSString *choiceObjectAttributeNameInIntermediateEntity;

/** Represents the ManagedObject that provides the .order variable, acting as an intermediary */
@property (nonatomic, copy) NSString *intermediateEntityName;

@end



