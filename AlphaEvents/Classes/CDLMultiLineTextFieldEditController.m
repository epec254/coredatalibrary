//
//  CDLMultiLineTextFieldEditController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary
//
//  Original concept based on code by Jeff LaMarche (SuperDB) - http:// iphonedevelopment.blogspot.com


#import "CDLMultiLineTextFieldEditController.h"
#import "UIColor+MoreColors.h"

@implementation CDLMultiLineTextFieldEditController
@synthesize textView = _textView;


- (void)dealloc 
{
	[_textView release];
    [super dealloc];
}


#pragma mark -
#pragma mark init

- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath  
{
	if (self = [super initForManagedObject:managedObject withLabel:label forKeyPath:keyPath]) {
		if ([[self.attributeKeyPath componentsSeparatedByString:@"."] count] > 1) {
			[CDLUtilityMethods raiseExceptionWithName:@"CDLMultiLineTextFieldEditController invalid input" reason:@"attributeKeyPath must be only a key"];
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark saving

- (void)updateObjectWithValues
{	
    // Pass current value to the edited object, then pop.
	[self.managedObject setValue:self.textView.text forKey:self.attributeKeyPath]; 
	
	[super validateSaveAndPop];
}
#pragma mark -
#pragma mark view life cycle

- (void)viewDidLoad 
{
    
	
	UITextView *theTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 10.0, 280.0, 161.0)];
	theTextView.editable = YES;
	theTextView.font = [UIFont systemFontOfSize:17.0];
	theTextView.textColor = [UIColor tableCellNonEditableTextColor];
	theTextView.keyboardType = self.attributeKeyboardType;
	[theTextView becomeFirstResponder];
	self.textView = theTextView;
	
	[theTextView release];
	
	[super viewDidLoad];
}


#pragma mark -
#pragma mark Tableview methods


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *MultiLineTextFieldEditCellIdentifier = @"MultiLineTextFieldEditCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MultiLineTextFieldEditCellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:MultiLineTextFieldEditCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.editingAccessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		[cell.contentView addSubview:self.textView];
    }

	self.textView.text = self.attributeStringValue;
	

	
	// This doesn't work - no matter where I put it. It's almost as if this property is readonly
	//textView.selectedRange = NSMakeRange([string length], 0);;

	
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 181.0;
}


@end
	
