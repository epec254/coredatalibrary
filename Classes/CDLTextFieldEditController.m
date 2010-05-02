//
//  CDLTextFieldEditController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the BSD License
//
//  code.google.com/p/coredatalibrary

#import "CDLTextFieldEditController.h"
#import "UIColor+MoreColors.h"
#import "NSManagedObject+TypeOfProperty.h"

static NSInteger textFieldTag = 3003;

@implementation CDLTextFieldEditController

@synthesize textField = _textField;

#pragma mark -
#pragma mark memory mgt
- (void)dealloc 
{
	[_textField release];
	_textField = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark init

- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath  
{
	if (self = [super initForManagedObject:managedObject withLabel:label forKeyPath:keyPath]) {

		if (self.isNumberProperty) {
			self.attributeKeyboardType = UIKeyboardTypeNumbersAndPunctuation;
		}
		
		if ([[self.attributeKeyPath componentsSeparatedByString:@"."] count] > 1) {
			[CDLUtilityMethods raiseExceptionWithName:@"CDLTextFieldEditController invalid input" reason:@"attributeKeyPath must be only a key"];
		}
		
	}
	
	return self;
}




#pragma mark -
#pragma mark view life cycle

- (void)viewDidLoad
{
		
	//create the text field
	UITextField *aTextField = [[UITextField alloc] initWithFrame:CGRectMake(30.0, 10.0, 280.0, 25.0)];
	aTextField.returnKeyType = UIReturnKeyDone;		
	aTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
	aTextField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
	aTextField.tag = textFieldTag;
	aTextField.clearButtonMode = UITextFieldViewModeAlways;
	aTextField.delegate = self;
	aTextField.keyboardType = self.attributeKeyboardType;
	aTextField.placeholder = self.attributeLabel;
	
	self.textField = aTextField;
	
	[aTextField release];
	[self.textField becomeFirstResponder];
	
	//make the fields appear centered between the nav bar and picker
	CGFloat headerHeight = (180.0 - (self.tableView.rowHeight)) / 2;  
	self.tableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, headerHeight)] autorelease];
	//credit to this from: http:// stackoverflow.com/questions/1284997/uitableviewcells-to-be-in-center-of-uitableview
	
	[super viewDidLoad];

}

#pragma mark -
#pragma mark saving
							
- (void)updateObjectWithValues
{	
	// Pass current value to the edited object
	[self.managedObject setValue:self.textField.text forKey:self.attributeKeyPath];
	
	[super validateSaveAndPop];
}


#pragma mark -
#pragma mark Table View Data Source Methods


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *textFieldCellIdentifier = @"textFieldCellIdentifier";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textFieldCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.editingAccessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		[cell.contentView addSubview:self.textField];
    } 

	self.textField.text = self.attributeStringValue;
		
    return cell;
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self updateObjectWithValues]; //save if done is pressed
	
	return YES;
}


#pragma mark -
#pragma mark property accesors

- (BOOL) isNumberProperty
{	
	NSString *propertyType = [self.managedObject classOfKey:self.attributeKeyPath];
	
	return [propertyType rangeOfString:@"NSNumber"].location != NSNotFound;
}



@end

