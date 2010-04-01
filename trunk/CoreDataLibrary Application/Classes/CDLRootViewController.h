//
//  CDLRootViewController.h
//
//  Created by Eric Peter on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface CDLRootViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
	
@private
																			
	NSFetchedResultsController		*_fetchedResultsController;			// controller to coordinate with table view
	
	NSString						*_entityName;						// core data name of entity controller manages
	NSString						*_entityFriendlyName;				// human readable name of entity controller manages
	
	NSArray							*_sortKeyPaths;					// core data names of fields used to sort entities before display
	
	NSPredicate						*_filterPredicate;					// optional filter on the data
	
	NSString						*_sectionKeyPath;					// core data name of key for to create sections by
	

	NSArray							*_alphaSectionIndexTitles;
	BOOL							_sectionIndexTitlesEnabled;			//YES to display titles, NO otherwise
	
	NSString						*_cellTextLabelKeyPath;
	NSString						*_cellDetailTextLabelKeyPath;
	BOOL							_fullyLoaded;
	
	NSString						*_detailViewPropertyListFile;


}

@property (nonatomic, copy) NSString *detailViewPropertyListFile;
@property (nonatomic, copy) NSString *cellTextLabelKeyPath;
@property (nonatomic, copy) NSString *cellDetailTextLabelKeyPath;
@property (nonatomic, assign) BOOL sectionIndexTitlesEnabled;
- (id) initWithStyle: (UITableViewStyle) style;
- (id) initForListViewControllerStructure:(NSString *) fullPathToPropertyListFile;
- (void)add:(id)sender;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void) reloadSectionIndexTitles;

@property (nonatomic, retain)	NSFetchedResultsController		*fetchedResultsController;

@property (nonatomic, retain)	NSArray 						*sortKeyPaths;
@property (nonatomic, copy)		NSString 						*entityName;
@property (nonatomic, copy)		NSString						*entityFriendlyName;

@property (nonatomic, copy)		NSString						*sectionKeyPath;
@property (nonatomic, retain)	NSPredicate						*filterPredicate;

@property (nonatomic, retain)	NSArray							*alphaSectionIndexTitles;

@end


