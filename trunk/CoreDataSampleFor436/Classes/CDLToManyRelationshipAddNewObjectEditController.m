//
//  CDLToManyRelationshipAddNewObjectController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import "CDLToManyRelationshipAddNewObjectEditController.h"
#import "DataController.h"

@implementation CDLToManyRelationshipAddNewObjectEditController

@synthesize keyForRelationship = _keyForRelationship;
@synthesize newObject = _newObject;
@synthesize editingObject = _editingObject;
@synthesize relationshipEntityName = _relationshipEntityName;
@synthesize label = _label;
@synthesize delegate = _delegate;

- (void)dealloc
{
	[_relationshipEntityName release];
	_relationshipEntityName = nil;
	[_label release];
	_label = nil;

	[_editingObject release];
	_editingObject = nil;

	[_newObject release];
	_newObject = nil;


	[_keyForRelationship release];
	_keyForRelationship = nil;

	[super dealloc];
}

#pragma mark -
#pragma mark init

- (id) initForPropertyList:(NSString *) fullPathToPropertyListFile editingObject:(NSManagedObject *)editingObject relationshipEntityName:(NSString *) relationshipEntityName relationshipKey:(NSString *) relationshipKey label:(NSString *) label
{
	
	//Create a new NSManagedObject to add
	NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:relationshipEntityName inManagedObjectContext:[[DataController sharedDataController] managedObjectContext]];
	
	self.newObject = newObject;
	
	if (self = [super initForPropertyList:fullPathToPropertyListFile managedObject:self.newObject]) {
		self.relationshipEntityName = relationshipEntityName;
		self.label = label;
		self.keyForRelationship = relationshipKey;
		self.editingObject = editingObject;
	}
	
	return self;
}


- (void)viewWillAppear:(BOOL)animated {	
	
	[super viewWillAppear:animated];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] 
									 initWithTitle:NSLocalizedString(@"Cancel", 
																	 @"Cancel - for button to cancel changes")
									 style:UIBarButtonSystemItemCancel
									 target:self
									 action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
								   initWithTitle:NSLocalizedString(@"Add", 
																   @"Save - for button to save changes")
								   style:UIBarButtonItemStyleDone
								   target:self 
								   action:@selector(addNewRelatedObject)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	self.navigationItem.title = [NSString stringWithFormat:@"Add %@", self.label];
	
	[self setEditing:YES animated:NO];
	
	[self.tableView reloadData];
}

- (void)cancel {
	
	[MANAGED_OBJECT_CONTEXT deleteObject:self.newObject];
    [self.navigationController popViewControllerAnimated:YES];
	//TODO: don't abuse our deleaget like this.
	[self.delegate fieldEditController:nil didEndEditingCanceled:YES];
}

- (void) addNewRelatedObject
{
	NSError *error;
    if (![self.managedObject validateForUpdate:&error]) {
		//TODO: implement a better display of errors
		UIAlertView *validationErrorAlert = [[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"You entered one or more invalid value(s)." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Fix", nil];
		[validationErrorAlert show];
		[validationErrorAlert release];
	} else {
		
		
//		NSEntityDescription *theDescription = [self.editingObject entity];
//		NSDictionary *relationshipsByName = [theDescription relationshipsByName];
//		NSRelationshipDescription *relationshipFromEditingToNew = [relationshipsByName objectForKey:self.keyForRelationship];
//		
//		NSRelationshipDescription *relationshipFromNewToEditing = [relationshipFromEditingToNew inverseRelationship];
//		
//		NSString *nameOfRelationshipFromNewToEditing = [relationshipFromNewToEditing name];
//		
		
		NSString *attributeKeyFirstLetterCapitalized = [self.keyForRelationship stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.keyForRelationship substringToIndex:1] capitalizedString]];
		
		//NSString *removeFunctionString = [NSString stringWithFormat:@"remove%@Object:", attributeKeyFirstLetterCapitalized];
		NSString *addFunctionString = [NSString stringWithFormat:@"add%@Object:", attributeKeyFirstLetterCapitalized];
		//SEL removeFunction = NSSelectorFromString(removeFunctionString); //selector to remove the associated record
		SEL addFunction = NSSelectorFromString(addFunctionString); //selector to add an associated record

		[self.editingObject performSelector:addFunction withObject:self.newObject];

		
		[[DataController sharedDataController] saveFromSource:@"to many add new object"];
		[self.navigationController popViewControllerAnimated:YES];
		[self.delegate fieldEditController:nil didEndEditingCanceled:NO];
	}
}
@end
