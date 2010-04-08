//
//  CDLToManyRelationshipTableRowController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary
//
#import "CDLRelationshipTableRowController.h"

@interface CDLToManyRelationshipTableRowController : CDLRelationshipTableRowController {
@private
	NSManagedObject *_relationshipObject;
}
/** related object this row is managing */
@property (nonatomic, retain) NSManagedObject *relationshipObject;

- (id) initForDictionary:(NSDictionary *) rowInformation forRelationshipObject:(NSManagedObject *) relationshipObject;

@end
