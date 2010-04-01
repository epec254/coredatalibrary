//
//  SingleSelectionListViewController.h
//
// Created by Eric Peter for Wash U CSE 436
// Changed to allow easy use with Core Data
// heavily modified from original code by:
//  Created by Jeff LaMarche on 2/18/09.
//

#import "CDLAbstractFieldEditController.h"
//#import <objc/runtime.h>
//#import <objc/message.h>

//static const char *getPropertyType(objc_property_t property) {
//    const char *attributes = property_getAttributes(property);
//    char buffer[1 + strlen(attributes)];
//    strcpy(buffer, attributes);
//    char *state = buffer, *attribute;
//    while ((attribute = strsep(&state, ",")) != NULL) {
//        if (attribute[0] == 'T') {
//            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
//        }
//    }
//    return "@";
//}

@class CDLRootViewController;
@interface CDLToOneRelationshipEditController : CDLAbstractFieldEditController 
{
	
	NSString		*_choicesDisplayPropertyKey;			// the name of the property of the NSManagedObjects in the listChoices to display to the user.
	NSString		*_choicesEntityName;					// name of the entity that we are choosing
														//	NSString		*choicesEntityFriendlyName;			// friendly name of the entity we are choosing
	
@protected
	NSArray			*_listOfChoices;						// array of NS Managed Objects that are the choices
	UITableViewCell *_currentlyChosen;					// pointer to the currently chosen table view cell (weak reference)
	NSPredicate		*_choicesPredicate;					//optional filter for choices
	
}

@property (nonatomic, retain) NSArray *listOfChoices;

@property (nonatomic, copy) NSString *choicesDisplayPropertyKey;

@property (nonatomic, copy) NSString *choicesEntityName;

@property (nonatomic, assign) UITableViewCell *currentlySelectedCell;

@property (nonatomic, retain) NSPredicate *choicesPredicate;

- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath;

- (NSManagedObject *) selectedObjectAtRelationship;
- (NSString *) keyForRelationship;
@end

