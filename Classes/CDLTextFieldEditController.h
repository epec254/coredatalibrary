//
//  CDLTextFieldEditController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import "CDLAbstractFieldEditController.h"


/** this class supports String and Number properties. */
@interface CDLTextFieldEditController : CDLAbstractFieldEditController <UITextFieldDelegate> {
@private
	UITextField							*_textField;
}


@property (nonatomic, retain) UITextField *textField;

/** Does the attributeKeyPath represent a NSNumber */
@property (nonatomic, readonly) BOOL isNumberProperty;

@end
