//
//  FavoritesViewController.m
//  WebMusicDownload
//
//  Created by Zen David on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"


@implementation FavoritesViewController

@synthesize thisTableView;
@synthesize favoritesDict;
@synthesize favoriteTitles;
@synthesize navBarItem;
@synthesize favorites;

- (IBAction)actEdit:(id)sender{
    [self.thisTableView setEditing:YES animated:YES];
}
- (void)actDone:(id)sender{

    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [self.thisTableView setEditing:NO animated:YES];
    
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
-(void)getBookmakrsDate {
    [self.favorites getFavorites];
    self.favoritesDict = self.favorites.favoritesList;
  
    //get allkey
    NSEnumerator *enumerator = [self.favoritesDict keyEnumerator];
    NSString* _key;
    
    NSMutableArray* bookmarkItems =[[NSMutableArray alloc] initWithCapacity:[self.favoritesDict count]];
    
    while ((_key = [enumerator nextObject])) {
        /* code that uses the returned key */
        NSString* _values = [self.favoritesDict objectForKey:_key];
        //self.favoriteTitles 
        NSArray* _items = [[NSArray alloc ] initWithObjects:
                           _key,
                           _values,
                           nil];
        [bookmarkItems addObject:_items];
        [_items release];
    }
    self.favoriteTitles = bookmarkItems;
    [bookmarkItems release];
    //self.favoriteTitles = [NSArray arrayWithArray:[self.favoritesDict allValues]];
}

- (id)delegate
{
    return delegate;
}
- (void)setDelegate:(id)aDelegate
{
    delegate = aDelegate;
}
- (void)navToAddress:(NSString*)url
{
    [delegate doBookmarksNav:url];
}//end delegate

#pragma mark - Class Base
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
    [thisTableView release];
    [favoritesDict release];
    [favoriteTitles release];
    [navBarItem release];
    [favorites release];
    
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
    // Add our custom add button as the nav bar's custom right view
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] 
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone                                           target:self
                                   action:@selector(actDone:)];                                  ;
    
	self.navBarItem.rightBarButtonItem = doneButton;
    [doneButton release];
    //init bookmarks
    Favorites *f_= [[Favorites alloc] init];
    self.favorites =f_;
    [f_ release];
    //[self getBookmakrsDate];
	
}


- (void)viewDidUnload
{
    self.thisTableView =nil;
    self.favoritesDict =nil;
    self.favoriteTitles =nil;
    self.navBarItem =nil;
    self.favorites =nil;
    
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
    return [self.favoritesDict count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSUInteger row =[indexPath row];
    NSArray* bookmarkItem = [self.favoriteTitles objectAtIndex:row];
    cell.textLabel.text =[bookmarkItem objectAtIndex:1];
    
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
    
    //get url
    NSString* url = [[self.favoriteTitles objectAtIndex:row] objectAtIndex:0];
    //NSLog(@"Url is :%@",url);
    [self navToAddress:url];
    //NSString* url = 
    //remove form super view
    //nav to the url
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //DEL ITEM
    [self.favoriteTitles removeObjectAtIndex:indexPath.row];
    
    //SAVE
    //TO Dict
    NSEnumerator * enumerator = [self.favoriteTitles  objectEnumerator];
    NSArray* element;
    self.favoritesDict =[NSMutableDictionary dictionary];
    
    while((element = [enumerator nextObject]))
    {
        // Do your thing with the object.
        
        [self.favoritesDict setObject:[element objectAtIndex:1 ] forKey:[element objectAtIndex:0]];
                
        NSLog(@"title is:%@",[element objectAtIndex:1 ]);
    }
    //save
    [self.favorites saveFavorites:self.favoritesDict];
    
    //reloads
    [self getBookmakrsDate];
    [self.thisTableView reloadData];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}



@end
