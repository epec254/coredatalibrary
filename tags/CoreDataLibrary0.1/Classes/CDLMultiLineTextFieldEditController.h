//
//  CDLMultiLineTextFieldEditController.h
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

@interface CDLMultiLineTextFieldEditController : CDLAbstractFieldEditController 
{
	UITextView	*_textView;
	
}
@property (nonatomic, retain) UITextView *textView;

@end
