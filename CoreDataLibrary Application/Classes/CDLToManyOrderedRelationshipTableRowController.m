//
//  CDLToManyOrderedRelationshipTableRowController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import "CDLToManyOrderedRelationshipTableRowController.h"


@implementation CDLToManyOrderedRelationshipTableRowController

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}


@end
