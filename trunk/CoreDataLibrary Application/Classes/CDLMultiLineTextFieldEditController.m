
//
//  Based on code created by Jeff LaMarche on 2/10/09.
//  Modified by Eric Peter

#import "CDLMultiLineTextFieldEditController.h"
#import "UIColor+MoreColors.h"

@implementation CDLMultiLineTextFieldEditController
@synthesize textView = _textView;

#pragma mark -
#pragma mark initialization 



- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath  
{
	if (self = [super initWithMaximumFields:1 forManagedObject:managedObject]) {
		self.navigationItem.title = [NSString stringWithFormat:@"Edit %@", label];
		self.attributeLabels = [NSArray arrayWithObject:label];
		self.attributeKeyPaths = [NSArray arrayWithObject:keyPath];
		
	}
	
	return self;
}

#pragma mark -
#pragma mark saving

- (void)updateObjectWithValues
{
	NSString *fieldKey = [self.attributeKeyPaths objectAtIndex:0]; //keyed name of the  field in Managed Object
	
    // Pass current value to the edited object, then pop.
	[self.managedObject setValue:self.textView.text forKey:fieldKey]; 
	
	[super validateAndPop];
}
#pragma mark -
#pragma mark view life cycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	UITextView *theTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 10.0, 280.0, 161.0)];
	theTextView.editable = YES;
	theTextView.font = [UIFont systemFontOfSize:17.0];
	theTextView.textColor = [UIColor tableCellNonEditableTextColor];
	[theTextView becomeFirstResponder];
	self.textView = theTextView;
	
	[theTextView release];

}

- (void)viewDidAppear:(BOOL)animated 
{
	[self.textView becomeFirstResponder];
	
    [super viewDidAppear:animated];
}


#pragma mark -
#pragma mark Tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *MultiLineTextFieldEditCellIdentifier = @"MultiLineTextFieldEditCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MultiLineTextFieldEditCellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:MultiLineTextFieldEditCellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		[cell.contentView addSubview:self.textView];
    }

	self.textView.text = self.attributeStringValue;
	self.textView.keyboardType = [[self.keyboardTypes objectAtIndex:indexPath.row] intValue];

	
	// This doesn't work - no matter where I put it. It's almost as if this property is readonly
	//textView.selectedRange = NSMakeRange([string length], 0);;

	
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 181.0;
}

- (void)dealloc 
{
	[_textView release];
    [super dealloc];
}


@end
	
