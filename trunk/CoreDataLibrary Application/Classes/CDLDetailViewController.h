
#import "CDLTableSectionController.h"


@interface CDLDetailViewController : UITableViewController <CDLTableSectionControllerDelegate> {

@private
	NSManagedObject *_managedObject;
	NSArray			*_sectionControllers;
    
}

@property (nonatomic, copy)		NSArray				*sectionControllers;
@property (nonatomic, retain)	NSManagedObject		*managedObject;

- (id) initForPropertyList:(NSString *) fullPathToPropertyListFile forManagedObject:(NSManagedObject *)managedObject;

@end
