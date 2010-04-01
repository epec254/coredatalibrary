//
//  NSManagedObjectContext-insert.h
//  BEPersonalTrainingManager
//
//  Created by Eric Is Better on 2/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface NSManagedObjectContext(insert)
- (NSManagedObject *) insertNewObjectForEntityForName:(NSString *)name;
@end
