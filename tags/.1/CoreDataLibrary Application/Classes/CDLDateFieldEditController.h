/*
 DateViewController.h
 */

#import "CDLAbstractFieldEditController.h"

@interface CDLDateFieldEditController : CDLAbstractFieldEditController <UITableViewDelegate, UITableViewDataSource>
{
    UIDatePicker            *_datePicker;
	UITableView				*_dateTableView;
	NSDateFormatterStyle							_dateFormatterStyle;
	NSDateFormatterStyle							_timeFormatterStyle;
	NSDateFormatter									*_dateFormatter;

}

@property (nonatomic, assign) NSDateFormatterStyle dateFormatterStyle;
@property (nonatomic, assign) NSDateFormatterStyle timeFormatterStyle;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UITableView *dateTableView;

- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath withDateFormatterStyle: (NSDateFormatterStyle) dateFormatterStyle withTimeFormatterStyle: (NSDateFormatterStyle) timeFormatterStyle;

- (IBAction) dateChanged;

@end