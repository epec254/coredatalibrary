//
//  LongTextFieldViewController.h
//
//
// Created by Eric Peter for Wash U CSE 436
// Changed to allow easy use with Core Data
// heavily modified from original code by:
//  Created by Jeff LaMarche on 2/18/09.


#import "CDLAbstractFieldEditController.h"

@interface CDLMultiLineTextFieldEditController : CDLAbstractFieldEditController 
{
	UITextView	*_textView;
	
}
@property (nonatomic, retain) UITextView *textView;

- (void)updateObjectWithValues;

- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath;

@end
