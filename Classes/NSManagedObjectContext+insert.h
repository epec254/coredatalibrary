//
//  NSManagedObjectContext+insert.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the BSD License
//
//  code.google.com/p/coredatalibrary

@interface NSManagedObjectContext(insert)
/**
 Easy accessor method to add a new object.
 */
- (NSManagedObject *) insertNewObjectForEntityForName:(NSString *)name;
@end
