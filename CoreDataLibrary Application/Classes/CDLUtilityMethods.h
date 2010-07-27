//
//  CDLUtilityMethods.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary



@interface CDLUtilityMethods : NSObject 

+ (BOOL) isLoadedStringValid:(NSString *) loadedString;
+ (BOOL) isLoadedArrayValid:(NSArray *)loadedArray;
+ (BOOL) isLoadedDictionaryValid:(NSDictionary *)loadedDictionary;

+ (NSString *) stringValueForKeyPath:(NSString *) keyPath inObject:(id) object;
+ (NSString *) stringValueForKeyPath:(NSString *) keyPath inObject:(id) object withDateFormatter:(NSDateFormatter *) dateFormatter;
+ (void) raiseExceptionWithName:(NSString *) name reason:(NSString *) reason;

@end
