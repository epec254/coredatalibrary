//
//  DataController.h
//  CoreDataUILibrary
//
//  Created by Eric Peter on 12/24/09.
//

#import "NSManagedObjectContext+insert.h"

#define MANAGED_OBJECT_CONTEXT [[DataController sharedDataController] managedObjectContext]
#define SQL_DATABASE_NAME @"___PROJECTNAMEASIDENTIFIER___"

#define ORDER_KEY_NAME  @"order"

@interface DataController : NSObject {
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;	    
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;

- (void) handleError:(NSError *)error fromSource:(NSString *)sourceString;
- (void) saveFromSource:(NSString *)source;

- (NSString *)applicationDocumentsDirectory;

+ (DataController *)sharedDataController;

@end
