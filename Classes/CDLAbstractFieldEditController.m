//
//  CDLAbstractFieldEditController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary


#import "CDLAbstractFieldEditController.h"
#import "DataController.h"

@implementation CDLAbstractFieldEditController

@synthesize attributeLabel = _attributeLabel;
@synthesize attributeKeyPath = _attributeKeyPath;
@synthesize attributeKeyboardType = _attributeKeyboardType;
@synthesize inAddMode = _inAddMode;
@synthesize managedObject = _managedObject;

@synthesize delegate = _delegate;

#pragma mark -
#pragma mark memory management

- (void) dealloc
{
	
	[_managedObject release];
	_managedObject = nil;
	
	[_attributeLabel release];
	_attributeLabel = nil;
	
	[_attributeKeyPath release];
	_attributeKeyPath = nil;
	
	
	[super dealloc];
}

#pragma mark -
#pragma mark Initialization

- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath  
{
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.hidesBottomBarWhenPushed = YES;
		self.managedObject = managedObject;
		self.inAddMode = NO;
		
		self.navigationItem.title = [NSString stringWithFormat:@"Edit %@", label];
		self.attributeLabel = label;
		self.attributeKeyPath = keyPath;
		self.attributeKeyboardType = UIKeyboardTypeDefault;
	}
	
	return self;
}

//no rotation yet
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	
	// Configure the save and cancel buttons.

	NSString *saveDoneButtonTitle = (self.inAddMode) ? @"Done" : @"Save";
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:saveDoneButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(updateObjectWithValues)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];

}

#pragma mark -
#pragma mark Saving

- (void) updateObjectWithValues
{
	NSException *ex = [NSException exceptionWithName:@"Abstract method called" reason:NSLocalizedString(@"Abstract method - implement in subclass", @"Abstract method - implement in subclass") userInfo:nil];
	[ex raise];
}

- (void) validateSaveAndPop
{
	if (self.inAddMode) { //don't try to save or validate in add mode
		[self.navigationController popViewControllerAnimated:YES];
		[self.delegate fieldEditController:self didEndEditingCanceled:NO];
		return;
	}
	
	if (![self.managedObject validateForUpdate:NULL]) {
		//TODO: implement a better display of errors
		UIAlertView *validationErrorAlert = [[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"You entered an invalid value." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Fix", nil];
		[validationErrorAlert show];
		[validationErrorAlert release];
	} else {
		[[DataController sharedDataController] saveFromSource:@"text field edit"];
		[self.navigationController popViewControllerAnimated:YES];
		[self.delegate fieldEditController:self didEndEditingCanceled:NO];
	}
}
											 
#pragma mark -
#pragma mark Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == [alertView cancelButtonIndex]) {
	  [MANAGED_OBJECT_CONTEXT rollback];
	  [self cancel];
  }
}									 

#pragma mark -
#pragma mark cancel method

- (void) cancel
{
	if (self.inAddMode) { //if in add mode, remove the temporary object
		[MANAGED_OBJECT_CONTEXT deleteObject:self.managedObject];
	}
	[self.navigationController popViewControllerAnimated:YES];
	[self.delegate fieldEditController:self didEndEditingCanceled:YES];
}


#pragma mark -
#pragma mark property accesors

- (NSString *) attributeStringValue
{
	return [CDLUtilityMethods stringValueForKeyPath:self.attributeKeyPath inObject:self.managedObject];
}

- (id) attributeObjectValue
{
	return [self.managedObject valueForKeyPath:self.attributeKeyPath];
}

#pragma mark -
#pragma mark tableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSException *ex = [NSException exceptionWithName:@"Abstract method called" reason:NSLocalizedString(@"Abstract method - implement in subclass", @"Abstract method - implement in subclass") userInfo:nil];
	[ex raise];
	return nil;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	// prevents the rows from being selected.
	return nil;
}



@end
