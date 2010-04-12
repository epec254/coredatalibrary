//
//  CDLToManyRelationshipSectionController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import "CDLTableSectionController.h"


@interface CDLToManyRelationshipSectionController : CDLTableSectionController <CDLFieldEditControllerDelegate> {
	@protected
	id<CDLTableRowControllerProtocol> _addExistingObjectsRowController;
	id<CDLTableRowControllerProtocol> _addNewObjectRowController;

	NSDictionary *_rowInformation;

@private
	
	NSString *_rowLabel;
	
	NSString *_userProvidedFullKeyPath;
	
	NSString *_drillDownKeyPath;
	
	NSMutableArray *_mutableRowControllers;
	
	NSString *_relationshipEntityName;
	
	BOOL _showAddExistingObjects;
	BOOL _showAddNewObject;
	
	NSString *_addNewObjectPropertyListFile;
		
}

@property (nonatomic, copy) NSString *addNewObjectPropertyListFile;
@property (nonatomic, assign) BOOL showAddExistingObjects;
@property (nonatomic, assign) BOOL showAddNewObject;
@property (nonatomic, copy) NSString *relationshipEntityName;

/** Same as rowControllers in CDLTableSectionController but mutable */
@property (nonatomic, retain) NSMutableArray *mutableRowControllers;

/** Dictionary to allow creation of new rowControllers when objects are added */
@property (nonatomic, readonly) NSDictionary *rowInformation;

/** Not currently implemented */
@property (nonatomic, copy) NSString *drillDownKeyPath;

/** Label to show on the Add row */
@property (nonatomic, copy) NSString *rowLabel;

/** Provided as attributeKeyPath by the user, contains the full KVC compliant path to the displayed property */
@property (nonatomic, copy) NSString *userProvidedFullKeyPath;

/** Calculated from the userProvidedFullKeyPath, returns the first part of the keyPath which is the relationship property in the managedObject we are viewing */
@property (nonatomic, readonly) NSString *keyForRelationship;





@property (nonatomic, readonly) NSString *sortKeyName;


@end
