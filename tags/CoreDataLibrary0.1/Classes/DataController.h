//
//  DataController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the BSD License
//
//  code.google.com/p/coredatalibrary

//  Based from Apple's provided Navigation-Controller CoreData template

#import "NSManagedObjectContext+insert.h"

#define MANAGED_OBJECT_CONTEXT [[DataController sharedDataController] managedObjectContext]
#define SQL_DATABASE_NAME @"___PROJECTNAMEASIDENTIFIER___"

@interface DataController : NSObject {
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;	    
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;

/**
 Print a log message and exit the application.  Called whenever a CoreData related method fails.
 @parm error NSError object describing the issue
 @param sourceString NSString describing where in code it was called from
 */
- (void) handleError:(NSError *)error fromSource:(NSString *)sourceString;

/** 
 Save the ManagedObjectContext
 @param source String describing where in code the save takes place
 */
- (void) saveFromSource:(NSString *)source;

- (NSString *)applicationDocumentsDirectory;

/**
 Singleton accessor 
 */
+ (DataController *)sharedDataController;

@end
