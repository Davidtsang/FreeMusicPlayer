//
//  FindSongsViewController.m
//  WebMusicDownload
//
//  Created by Zen David on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FindSongsViewController.h"


@implementation FindSongsViewController
@synthesize  needDownFiles;
@synthesize selectedFiles;
@synthesize  selectFilesTable;
@synthesize navItem;


-(IBAction)beCancel:(id)sender{
    if (self.view.superview) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(doRemoveFromSuperview)];
        
        //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        //[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
        [self.view setFrame:CGRectMake(0,480.0f, 320.0f, 460.0f)];
        [UIView commitAnimations];
        //[self.view removeFromSuperview];
        
    }
    
}
- (void)doRemoveFromSuperview{
    [self.view removeFromSuperview];
}


-(IBAction)beDone:(id)sender{
	
	//send selecedFile to app
	//appDelegate.selectedDownloadFiles =self.selectedFiles;
	
	//save
	//[appDelegate saveSelectedFilesToTask:self.selectedFiles];
	//[appDelegate beginDownload];
	
	//begin download
    if (self.view.superview) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(doRemoveFromSuperview)];
        
        //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        //[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
        [self.view setFrame:CGRectMake(0,480.0f, 320.0f, 460.0f)];
        [UIView commitAnimations];
        //[self.view removeFromSuperview];
        
    }
    //[appDelegate addUrlsDownload:[self.selectedFiles allKeys]];
    NSMutableArray *needDownURLs =[[NSMutableArray alloc] initWithArray:[self.selectedFiles allKeys]];
    [appDelegate addURLsDownload:needDownURLs];
    [needDownURLs release];
	
}
#pragma mark -Class Base

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [selectFilesTable release];
	[selectedFiles release];
	[needDownFiles release];
    [navItem release];

    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navItem.title =@"Add to Player";
    
    // Add our custom add button as the nav bar's custom right view
	//UIBarButtonItem *biDone = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"下一步", @"")
	//															   style:UIBarButtonItemStyleBordered
	//															  target:self
	//															  action:@selector(nextStepAction)] autorelease];
    UIBarButtonItem *biDone =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(beDone:)] ;
    
    UIBarButtonItem *biCancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(beCancel:)] ;

    
	self.navItem.rightBarButtonItem = biDone;	
    self.navItem.leftBarButtonItem =biCancel;
    [biDone release];
    [biCancel release];
    //init selectedfiles
	self.selectedFiles = [NSMutableDictionary dictionary];
	
	//初始化应用程序委托
	appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//add one file to start
	NSString *fileURI =[[self.needDownFiles objectAtIndex:0] objectAtIndex:1];
	[self.selectedFiles setObject:[self.needDownFiles objectAtIndex:0] forKey:fileURI];
    
}
- (void)refreshData
{
    [selectedFiles removeAllObjects];
    [selectFilesTable reloadData];
}
- (void)viewDidUnload
{
    self.selectFilesTable =nil;
	self.selectedFiles =nil;
	self.needDownFiles =nil;
    self.navItem =nil;

    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.needDownFiles count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSUInteger row =[indexPath row];
	
	NSString *fileURI =[[self.needDownFiles objectAtIndex:row] objectAtIndex:1];
	
	UIImage *imgUncheck = [UIImage imageNamed:@"checkbox_uncheck.png"];
	UIImage *imgChecked = [UIImage imageNamed:@"checkbox_checked.png"];
	
	if ([self.selectedFiles objectForKey:fileURI]==nil) {
		cell.imageView.image =imgUncheck;
	}else {
		cell.imageView.image =imgChecked;
	}
    
    
	
	//cell.imageView.image =imgUncheck;
	cell.textLabel.text =[[self.needDownFiles objectAtIndex:row] objectAtIndex:0];  
	cell.detailTextLabel.text =fileURI;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	NSUInteger row =[indexPath row];
	
	//check and add file to selectfiles
	//1.check
	NSString *fileURI =[[self.needDownFiles objectAtIndex:row] objectAtIndex:1];
	if ([self.selectedFiles objectForKey:fileURI] == nil) {
		
		//2. add
		[self.selectedFiles  setObject:[self.needDownFiles objectAtIndex:row] forKey:fileURI];
	}else {
		//3. romove
		[self.selectedFiles removeObjectForKey:fileURI];
	}
	
	//reload tabel
	[self.selectFilesTable reloadData];

}

@end
