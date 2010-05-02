//
//  CDLDateFieldEditController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the BSD License
//
//  code.google.com/p/coredatalibrary
//
//  Original concept based on code by Jeff LaMarche (SuperDB) - http:// iphonedevelopment.blogspot.com

#import "CDLAbstractFieldEditController.h"

@interface CDLDateFieldEditController : CDLAbstractFieldEditController
{
    UIDatePicker							*_datePicker;
	UITableView								*_dateTableView;
	NSDateFormatterStyle					_dateFormatterStyle;
	NSDateFormatterStyle					_timeFormatterStyle;
	NSDateFormatter							*_dateFormatter;

}

@property (nonatomic, assign) NSDateFormatterStyle dateFormatterStyle;
@property (nonatomic, assign) NSDateFormatterStyle timeFormatterStyle;
@property (nonatomic, readonly) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UITableView *dateTableView;

- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath withDateFormatterStyle: (NSDateFormatterStyle) dateFormatterStyle withTimeFormatterStyle: (NSDateFormatterStyle) timeFormatterStyle;

- (IBAction) dateChanged;

@end