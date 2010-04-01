//
//  MOToManyRelationshipSectionController.h
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLTableSectionController.h"
#import "CDLAbstractFieldEditController.h"

@class CDLToManyOrderedRelationshipAddTableRowController;

@interface CDLToManyOrderedRelationshipSectionController : CDLTableSectionController <CDLFieldEditControllerDelegate> {
@private
	CDLToManyOrderedRelationshipAddTableRowController *_addRowController;
	
	NSString *_rowLabel;
	
	NSString *_userProvidedFullKeyPath;
	
	NSString *_drillDownKeyPath;
	NSMutableArray *_sortedObjects;
	
	NSMutableArray *_mutableRowControllers;
	NSDictionary *_rowInformation;
	
	NSString *_entityTypeOfOrderedRelationship;
}

@property (nonatomic, retain) NSMutableArray *mutableRowControllers;
@property (nonatomic, copy) NSDictionary *rowInformation;
@property (nonatomic, copy) NSString *drillDownKeyPath;
@property (nonatomic, copy) NSString *rowLabel;

//Provided as attributeKeyPath by the user, contains the full KVC compliant path to the displayed property
@property (nonatomic, copy) NSString *userProvidedFullKeyPath;
//Calculated from the userProvidedFullKeyPath, returns the first part of the keyPath which is the relationship property in the managedObject we are viewing
@property (nonatomic, readonly) NSString *keyForRelationship;
//The 
@property (nonatomic, copy) NSString *entityTypeOfOrderedRelationship;



@property (nonatomic, retain) CDLToManyOrderedRelationshipAddTableRowController *addRowController;




@end

