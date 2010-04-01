//
//  MultiSelectionListViewController.h

// Eric Peter

#import "CDLToOneRelationshipEditController.h"


@interface CDLToManyOrderedRelationshipAddController : CDLToOneRelationshipEditController
{
	NSString			*_choicePropertyNameInIntermediateEntity;						//the name of the relationship relating the editing object to the choices.
	NSMutableSet		*_selectedObjects;
	
	//Represents the ManagedObject that provides the .order variable, acting as an interm
	NSString			*_relationshipIntermediateEntityName;
}

@property (nonatomic, copy) NSString *relationshipIntermediateEntityName;


- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath forRelationshipEntity:(NSString *)relationshipEntityName;

@property (nonatomic, retain) NSMutableSet *selectedObjects;
@property (nonatomic, copy) NSString *choicePropertyNameInIntermediateEntity;
@end



