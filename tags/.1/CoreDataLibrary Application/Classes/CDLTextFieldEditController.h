

#import "CDLAbstractFieldEditController.h"


//this class supports String and Number properties.
@interface CDLTextFieldEditController : CDLAbstractFieldEditController <UITextFieldDelegate> {
	
	UITextField							*_textField;
}

@property (nonatomic, retain) UITextField *textField;


- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath;


//-(IBAction) textFieldDone:(id)sender;

@end
