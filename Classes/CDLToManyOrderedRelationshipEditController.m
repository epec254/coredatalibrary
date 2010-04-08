//
//  CDLToManyOrderedRelationshipAddController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary
//
#import <objc/runtime.h>
#import <objc/message.h>
#import "DataController.h"
#import "CDLToManyOrderedRelationshipEditController.h"


@interface CDLToManyOrderedRelationshipEditController(PrivateMethods)
- (void) enableOrDisableSaveButton;
@end 

@implementation CDLToManyOrderedRelationshipEditController

@synthesize intermediateEntityName = _intermediateEntityName;
@synthesize choiceObjectAttributeNameInIntermediateEntity = _choiceObjectAttributeNameInIntermediateEntity;

- (void)dealloc
{
	
	[_choiceObjectAttributeNameInIntermediateEntity release];
	_choiceObjectAttributeNameInIntermediateEntity = nil;
	
	[_intermediateEntityName release];
	_intermediateEntityName = nil;
	
	[super dealloc];
}

- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath forChoicesEntity:(NSString *)choicesEntityName
{
	if (self = [super initForManagedObject:managedObject withLabel:label forKeyPath:keyPath forChoicesEntity:choicesEntityName]) {
		self.selectedObjects = [NSMutableSet set];	
		
		NSArray *keyParts = [self.attributeKeyPath componentsSeparatedByString:@"."];

				
		self.choiceObjectAttributeNameInIntermediateEntity = [keyParts objectAtIndex:1];

	}
	
	return self;
}

- (NSInteger) requiredNumberOfAttributesInKeyPath
{
	return 3;
}







#pragma mark -
#pragma mark saving

- (void)updateObjectWithValues
{
	NSString *attributeKeyFirstLetterCapitalized = [self.keyForRelationship stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.keyForRelationship substringToIndex:1] capitalizedString]];
	
	//NSString *removeFunctionString = [NSString stringWithFormat:@"remove%@Object:", attributeKeyFirstLetterCapitalized];
	NSString *addFunctionString = [NSString stringWithFormat:@"add%@Object:", attributeKeyFirstLetterCapitalized];
	//SEL removeFunction = NSSelectorFromString(removeFunctionString); //selector to remove the associated record
	SEL addFunction = NSSelectorFromString(addFunctionString); //selector to add an associated record
	
	//current place in the sorted order to put the next (new) object
	NSUInteger i = [[self.managedObject valueForKey:self.keyForRelationship] count];

	NSManagedObject *newIntermediateObject = nil;
	NSManagedObject *currentObject = nil;
	NSEnumerator *selectedObjectsEnumerator = [self.selectedObjects objectEnumerator];
	
	//loop through each selected object and make an intermediate object w/ the proper order
	while (currentObject = [selectedObjectsEnumerator nextObject]) {
		newIntermediateObject = [MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:self.intermediateEntityName];
		[newIntermediateObject setValue:[NSNumber numberWithInt:i] forKey:@"order"];
		[newIntermediateObject setValue:currentObject forKey:self.choiceObjectAttributeNameInIntermediateEntity];
		[self.managedObject performSelector:addFunction withObject:newIntermediateObject];
		i++;
	}

	[super validateSaveAndPop];
}



@end

