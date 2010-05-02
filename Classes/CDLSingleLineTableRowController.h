//
//  CDLSingleLineTableRowController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the BSD License
//
//  code.google.com/p/coredatalibrary

#import "CDLTableRowController.h"


@interface CDLSingleLineTableRowController : CDLTableRowController {
	NSDateFormatterStyle							_dateFormatterStyle;
	NSDateFormatterStyle							_timeFormatterStyle;
	NSDateFormatter									*_dateFormatter;

}

/** how to display the date in a NSDate attribute */
@property (nonatomic, assign) NSDateFormatterStyle dateFormatterStyle;
/** how to display the time in a NSDate attribute */
@property (nonatomic, assign) NSDateFormatterStyle timeFormatterStyle;
/** created on demand */
@property (nonatomic, readonly) NSDateFormatter *dateFormatter;

@end
