//
//  NSManagedObjectContext-insert.m
//  BEPersonalTrainingManager
//
//  Created by Eric Is Better on 2/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectContext+insert.h"
@implementation NSManagedObjectContext(insert)

-(NSManagedObject *) insertNewObjectForEntityForName:(NSString *)name
{
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
}

@end