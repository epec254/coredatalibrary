//
//  MOAddViewController.m
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLAddViewController.h"

#import "DataController.h"

@implementation CDLAddViewController

- (id) initForPropertyList:(NSString *) fullPathToPropertyListFile forManagedObject:(NSManagedObject *)managedObject
{
	if (self = [super initForPropertyList:fullPathToPropertyListFile forManagedObject:managedObject]) {
		for (CDLTableSectionController *sectionController in self.sectionControllers)
		{
			[sectionController setInAddMode:YES];
		}
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
								   initWithTitle:NSLocalizedString(@"Save", 
																   @"Save - for button to save changes")
								   style:UIBarButtonItemStyleDone
								   target:self 
								   action:@selector(validateAddAndPop)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	self.navigationItem.title = @"Add Item";
	
	[self setEditing:YES animated:NO];
        
	[self.tableView reloadData];
}

- (void)validateAddAndPop {
	NSError *error;
    if (![self.managedObject validateForUpdate:&error]) {
		//TODO: implement a better display of errors
		UIAlertView *validationErrorAlert = [[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"You entered one or more invalid value(s)." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Fix", nil];
		[validationErrorAlert show];
		[validationErrorAlert release];
	} else {
		[[DataController sharedDataController] saveFromSource:@"text field edit"];
		[self.navigationController popViewControllerAnimated:YES];
	}
}
- (void)cancel {

	[MANAGED_OBJECT_CONTEXT deleteObject:self.managedObject];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == [alertView cancelButtonIndex]) {
		[self cancel];
	}
}	


@end
