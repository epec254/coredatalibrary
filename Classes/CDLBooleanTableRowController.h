//
//  CDLBooleanTableRowController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary


#import "CDLTableRowController.h"


@interface CDLBooleanTableRowController : CDLTableRowController {
@private
	UISwitch										*_booleanSwitch;

}
@property (nonatomic, retain) UISwitch *booleanSwitch;

@end
