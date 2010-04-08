//
//  CDLRelationshipTableRowController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import "CDLTableRowController.h"


@interface CDLRelationshipTableRowController : CDLTableRowController{
	@private
	NSString										*_drillDownKeyPath;

}
/**
 if drill down is the type, what keypath to use to create the drill down - NOT IMPLEMENTED
 */
@property (nonatomic, copy) NSString *drillDownKeyPath;

/** key of the relationship in the ManagedObject (if the attributeKeyPath is x.y, this is x) */
@property (nonatomic, readonly) NSString *keyForRelationship;

/** key of the display property in the related ManagedObject (if the attributeKeyPath is x.y, this is y) */
@property (nonatomic, readonly) NSString *keyPathForRelationshipDisplayProperty;
@end
