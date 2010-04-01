#import "CDLTextFieldEditController.h"
#import "UIColor+MoreColors.h"



static NSInteger textFieldTag = 3003;

@implementation CDLTextFieldEditController

@synthesize textField = _textField;

#pragma mark -
#pragma mark init

- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath  
{
	if (self = [super initWithMaximumFields:1 forManagedObject:managedObject]) {
		self.navigationItem.title = [NSString stringWithFormat:@"Edit %@", label];
		self.attributeLabels = [NSArray arrayWithObject:label];
		self.attributeKeyPaths = [NSArray arrayWithObject:keyPath];
		
		if (self.isNumberProperty) {
			[self.keyboardTypes replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:UIKeyboardTypeNumbersAndPunctuation]];
		}
		
	}
	
	return self;
}




#pragma mark -
#pragma mark view life cycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	
	UITextField *aTextField = [[UITextField alloc] initWithFrame:CGRectMake(30.0, 10.0, 280.0, 25.0)];
	aTextField.returnKeyType = UIReturnKeyDone;		
	aTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
	aTextField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
	aTextField.tag = textFieldTag;
	aTextField.clearButtonMode = UITextFieldViewModeAlways;
	aTextField.delegate = self;
	aTextField.keyboardType = (UIKeyboardType)[[self.keyboardTypes objectAtIndex:0] intValue];
	aTextField.placeholder = [self.attributeLabels objectAtIndex:0];
	
	self.textField = aTextField;
	
	
	[aTextField release];

	
	//make the fields appear centered between the nav bar and picker
	CGFloat headerHeight = (180.0 - (self.tableView.rowHeight * [self.attributeKeyPaths count])) / 2;  
	self.tableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, headerHeight)] autorelease];
	//credit to this from: http:// stackoverflow.com/questions/1284997/uitableviewcells-to-be-in-center-of-uitableview
	
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.textField becomeFirstResponder];
}

#pragma mark -
#pragma mark saving
							
- (void)updateObjectWithValues
{	
	
	//basic information about this field
	NSString *fieldKey = [self.attributeKeyPaths objectAtIndex:0];
	
	// Pass current value to the edited object
	[self.managedObject setValue:self.textField.text forKey:fieldKey];
	
	
	[super validateAndPop];
}


#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

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


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	// prevents the rows from being selected.
	return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self updateObjectWithValues]; //save if done is pressed
	
	return YES;
}


#pragma mark -
#pragma mark memory mgt
- (void)dealloc 
{
	[_textField release];
	_textField = nil;

    [super dealloc];
}


@end

