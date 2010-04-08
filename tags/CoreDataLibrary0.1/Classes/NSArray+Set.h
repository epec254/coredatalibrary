//Code from Jeff LeMarche (More iPhone 3 Development - Dec 2009)

@interface NSArray(Set)
+ (id)arrayByOrderingSet:(NSSet *)set byKey:(NSString *)key ascending:(BOOL)ascending;
@end