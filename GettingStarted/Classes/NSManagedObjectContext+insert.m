//
//  NSManagedObjectContext+insert.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import "NSManagedObjectContext+insert.h"
@implementation NSManagedObjectContext(insert)

-(NSManagedObject *) insertNewObjectForEntityForName:(NSString *)name
{
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
}

@end