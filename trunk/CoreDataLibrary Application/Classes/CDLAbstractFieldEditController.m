//
//  AbstractModificationViewController.m
//
//  
// Created by Eric Peter for Wash U CSE 436
// Changed to allow easy use with Core Data
// heavily modified from original code by:
//  Created by Jeff LaMarche on 2/18/09.

#import "CDLAbstractFieldEditController.h"
#import "DataController.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation CDLAbstractFieldEditController

@synthesize inAddMode = _inAddMode;
@synthesize managedObject = _managedObject;
@synthesize attributeLabels = _attributeLabels, attributeKeyPaths = _attributeKeyPaths, keyboardTypes = _keyboardTypes;
@synthesize maximumFields = _maximumFields;
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Initialization

- (id) initWithMaximumFields:(NSInteger) maximum forManagedObject:(NSManagedObject *)managedObject
{
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.hidesBottomBarWhenPushed = YES;
		self.maximumFields = maximum;
		self.managedObject = managedObject;
		self.keyboardTypes = [NSMutableArray array];
		//all keyboards default to alphabet
		for (int i = 0; i < self.maximumFields; i++) {
			[self.keyboardTypes addObject:[NSNumber numberWithInt:UIKeyboardTypeAlphabet]];
		}
		self.inAddMode = NO;
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
//
//- (void) setInAddMode:(BOOL) addMode
//{
//	_inAddMode = addMode;
//	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(updateObjectWithValues)];
//	self.navigationItem.rightBarButtonItem = doneButton;
//	[doneButton release];
//}

#pragma mark -
#pragma mark Saving

- (void) updateObjectWithValues
{
	NSException *ex = [NSException exceptionWithName:@"Abstract method called" reason:NSLocalizedString(@"Abstract method - implement in subclass", @"Abstract method - implement in subclass") userInfo:nil];
	[ex raise];
	
	
}

- (void) validateAndPop
{
	if (self.inAddMode) { //don't try to save or validate in add mode
		[self.navigationController popViewControllerAnimated:YES];
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
	}
}
											 
#pragma mark -
#pragma mark Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == [alertView cancelButtonIndex]) {
	  [MANAGED_OBJECT_CONTEXT rollback];
	  [self.navigationController popViewControllerAnimated:YES];
  }
}									 

#pragma mark -
#pragma mark cancel method

- (void) cancel
{
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark property accesors

- (BOOL) isNumberProperty
{	
	NSString *attributeKey = [[[self.attributeKeyPaths objectAtIndex:0] componentsSeparatedByString:@"."] objectAtIndex:0]; //if the keyPath is x.y, just get X
	
	objc_property_t relationshipProperty = class_getProperty([self.managedObject class], [attributeKey cStringUsingEncoding:[NSString defaultCStringEncoding]]);
	
	NSString *relationshipAttributes = [NSString stringWithUTF8String: property_getAttributes(relationshipProperty)];
	
	return [relationshipAttributes rangeOfString:@"NSNumber"].location != NSNotFound;
}


- (NSString *) attributeStringValue
{
	
	return [self stringValueForObject:self.attributeObjectValue];
}

- (id) attributeObjectValue
{
	return [self.managedObject valueForKeyPath:[self.attributeKeyPaths objectAtIndex:0]];
}

- (NSString *) stringValueForObject:(id) anObject
{
	if ([anObject isKindOfClass:[NSString class]]) {
		return (NSString *) anObject;
	} else if ([anObject isKindOfClass:[NSNumber class]]) {
		return [anObject stringValue];
	} else {
		return [anObject description];
	}
	
}

#pragma mark -
#pragma mark Field arrays setters

- (void)setAttributeLabels:(NSArray *)newFieldNames
{
	if (_attributeLabels != newFieldNames) {
		
		if ([newFieldNames count] > self.maximumFields) { //more fields than this edit view supports
			NSException *e = [NSException exceptionWithName:@"Too Many Values" 
													 reason:[NSString stringWithFormat:@"You can't add more than %d fields to this control", self.maximumFields]
												   userInfo:nil];
			[e raise];
			
		} else { //ok to use this array
			[_attributeLabels release];
			_attributeLabels = [newFieldNames retain];
		}
	}
}

- (void)setAttributeKeyPaths:(NSArray *)newFieldKeys
{
	if (_attributeKeyPaths != newFieldKeys) {
		
		if ([newFieldKeys count] > self.maximumFields) { //more fields than this edit view supports
			NSException *e = [NSException exceptionWithName:@"Too Many Values" 
													 reason:[NSString stringWithFormat:@"You can't add more than %d fields to this control", self.maximumFields]
												   userInfo:nil];
			[e raise];
			
		} else { //ok to use this array
			[_attributeKeyPaths release];
			_attributeKeyPaths = [newFieldKeys retain];
		}
	}
}

- (void)setKeyboardTypes:(NSMutableArray *)newKeyboardTypes
{
	if (_keyboardTypes != newKeyboardTypes) {
		
		if ([newKeyboardTypes count] > self.maximumFields) { //more fields than this edit view supports
			NSException *e = [NSException exceptionWithName:@"Too Many Values" 
													 reason:[NSString stringWithFormat:@"You can't add more than %d field keyboards to this control", self.maximumFields]
												   userInfo:nil];
			[e raise];
			
		} else { //ok to use this array
			[_keyboardTypes release];
			_keyboardTypes = [newKeyboardTypes retain];
		}
	}
}

#pragma mark -
#pragma mark Keyboard type changer

-(void)setKeyboardType:(UIKeyboardType)theType forIndex:(NSUInteger)index
{
	if (index > self.maximumFields || index < 0) { //we can't have more kb's than # of fields
		NSException *e = [NSException exceptionWithName:@"Index Wrong" 
												 reason:[NSString stringWithFormat:@"You can't add more than %d field keyboards to this control", self.maximumFields]
											   userInfo:nil];
		[e raise];
	} else {
		[self.keyboardTypes replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:theType]];
	}
	
}

#pragma mark -
#pragma mark memory management

- (void) dealloc
{
	[_attributeLabels release];
	_attributeLabels = nil;
	[_attributeKeyPaths release];
	_attributeKeyPaths = nil;
	[_keyboardTypes release];
	_keyboardTypes = nil;
	[_managedObject release];
	_managedObject = nil;

	[super dealloc];
}
@end
