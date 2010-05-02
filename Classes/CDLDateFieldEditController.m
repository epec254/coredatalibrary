//
//  CDLDateFieldEditController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the BSD License
//
//  code.google.com/p/coredatalibrary
//
//  Original concept based on code by Jeff LaMarche (SuperDB) - http:// iphonedevelopment.blogspot.com

#import "CDLDateFieldEditController.h"
@implementation CDLDateFieldEditController

@synthesize dateFormatterStyle = _dateFormatterStyle;
@synthesize timeFormatterStyle = _timeFormatterStyle;
@synthesize dateFormatter = _dateFormatter;
@synthesize datePicker = _datePicker;
@synthesize dateTableView = _dateTableView;

- (void)dealloc 
{
    [_datePicker release];
	_datePicker = nil;
	
	[_dateTableView release];
	_dateTableView = nil;
	
	[_dateFormatter release];
	_dateFormatter = nil;
	
    [super dealloc];
}
#pragma mark -
#pragma mark initialization

- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath withDateFormatterStyle: (NSDateFormatterStyle) dateFormatterStyle withTimeFormatterStyle: (NSDateFormatterStyle) timeFormatterStyle
{
	if (self = [super initForManagedObject:managedObject withLabel:label forKeyPath:keyPath]) {
		
		self.dateFormatterStyle = dateFormatterStyle;
		self.timeFormatterStyle = timeFormatterStyle;
		
		if ([[self.attributeKeyPath componentsSeparatedByString:@"."] count] > 1) {
			[CDLUtilityMethods raiseExceptionWithName:@"CDLDateFieldEditController invalid input" reason:@"attributeKeyPath must be only a key"];
		}
	}
	
	return self;
}



- (void) viewDidUnload
{
	[super viewDidUnload];
	
	_dateFormatter = nil;
}
#pragma mark -
#pragma mark delegate from date picker

- (void)dateChanged
{
	[self.dateTableView reloadData];
}

#pragma mark -
#pragma mark saving

-(IBAction)updateObjectWithValues
{
	NSString *dateFieldKey = self.attributeKeyPath; //keyed name of the date field in Managed Object
	
	
    // Pass current value to the edited object, then pop.
	[self.managedObject setValue:self.datePicker.date forKey:dateFieldKey]; 

	[super validateSaveAndPop];
}

#pragma mark -
#pragma mark custom view creation

- (void)loadView
{
	
	UIView *theView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = theView;
    [theView release];
	//TODO: why do we create this tableView?
	UITableView *theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0) style:UITableViewStyleGrouped];
	theTableView.delegate = self;
	theTableView.dataSource = self;
	
	//make the date field appear centered between the nav bar and picker
	CGFloat headerHeight = (180.0 - theTableView.rowHeight) / 2;  //151 = 480 - 44 (nav bar) - 49 (tab bar) - 216 (picker) - 40 (good measure)
	theTableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, headerHeight)] autorelease];
	//credit to this hack from: http://stackoverflow.com/questions/1284997/uitableviewcells-to-be-in-center-of-uitableview
	
	[self.view addSubview:theTableView];
	self.dateTableView = theTableView;
	[theTableView release];
	
    UIDatePicker *theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0,200.0, 320.0, 216.0)];
	UIDatePickerMode pickerMode = UIDatePickerModeDateAndTime;
	
	if (self.timeFormatterStyle != NSDateFormatterNoStyle && self.dateFormatterStyle != NSDateFormatterNoStyle) {
		pickerMode = UIDatePickerModeDateAndTime;
	} else if (self.dateFormatterStyle == NSDateFormatterNoStyle) { //time only
		pickerMode = UIDatePickerModeTime;
	} else if (self.timeFormatterStyle == NSDateFormatterNoStyle) { //date only
		pickerMode = UIDatePickerModeDate;
	}
	
	theDatePicker.datePickerMode = pickerMode;
	
    self.datePicker = theDatePicker;
    [theDatePicker release];
    [self.datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.datePicker];
	
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

#pragma mark -
#pragma mark view lifecycle 

- (void)viewWillAppear:(BOOL)animated
{
	NSString *dateFieldKey = self.attributeKeyPath; //keyed name of the date field in Managed Object

	if ([self.managedObject valueForKey:dateFieldKey] != nil) //stored date value
		[self.datePicker setDate:[self.managedObject valueForKey:dateFieldKey] animated:YES];	
    else //no stored value yet
		[self.datePicker setDate:[NSDate date] animated:YES];
	[self dateChanged];
	
    [super viewWillAppear:animated];
}



#pragma mark -
#pragma mark Table View Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{

    static NSString *DateCellIdentifier = @"DateCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DateCellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DateCellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		[cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
		[cell.textLabel setTextColor:[UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0]];
    }
	
	cell.textLabel.text = [self.dateFormatter stringFromDate:self.datePicker.date];
	
	
	return cell;
}

#pragma mark -
#pragma mark property accesors

- (NSString *) attributeStringValue
{
	return [CDLUtilityMethods stringValueForKeyPath:self.attributeKeyPath inObject:self.managedObject withDateFormatter:self.dateFormatter];
}

- (NSDateFormatter *) dateFormatter{
	if (_dateFormatter != nil) {
		return _dateFormatter;
	}
	
	_dateFormatter = [[NSDateFormatter alloc] init];
	[_dateFormatter setDateStyle:self.dateFormatterStyle];
	[_dateFormatter setTimeStyle:self.timeFormatterStyle];
	
	return _dateFormatter;
}


@end