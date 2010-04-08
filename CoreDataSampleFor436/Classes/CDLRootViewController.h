//
//  CDLRootViewController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

@interface CDLRootViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
	
@private
																			
	NSFetchedResultsController		*_fetchedResultsController;			// controller to coordinate with table view
	
	NSString						*_entityName;						// core data name of entity controller manages
	NSString						*_controllerTitle;					// human readable name of entity controller manages
	
	NSArray							*_sortKeyPaths;						// core data names of fields used to sort entities before display
	
	NSPredicate						*_filterPredicate;					// optional filter on the data
	
	NSString						*_sectionNameKeyPath;				// core data name of key for to create sections by
	

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

- (id) initForListViewControllerStructure:(NSString *) fullPathToPropertyListFile;
- (void)add:(id)sender;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void) reloadSectionIndexTitles;

@property (nonatomic, retain)	NSFetchedResultsController		*fetchedResultsController;

@property (nonatomic, retain)	NSArray 						*sortKeyPaths;
@property (nonatomic, copy)		NSString 						*entityName;
@property (nonatomic, copy)		NSString						*controllerTitle;

@property (nonatomic, copy)		NSString						*sectionNameKeyPath;
@property (nonatomic, retain)	NSPredicate						*filterPredicate;

@property (nonatomic, retain)	NSArray							*alphaSectionIndexTitles;

@end


