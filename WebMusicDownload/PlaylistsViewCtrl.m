//
//  PlaylistsViewCtrl.m
//  WebMusicDownload
//
//  Created by Zen David on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlaylistsViewCtrl.h"
#import "PlayList.h"
#import "DefaultPlaylistDetailViewController.h"
#import "UserPlaylistDetailViewController.h"

@interface PlaylistsViewCtrl()
@property(nonatomic,retain) AddSongToPlaylistViewController *addSongToPlaylistView;
@property(nonatomic,retain)UIAlertView *addPlayListAlertView;
@property(nonatomic,retain) PlayList *playListObj;
-(void)showEditAlartView;
-(void)initUI;
-(void)initUserPlaylists;
-(void)showUserListDetail:(NSInteger)aID pName:(NSString *)aName;

@end

@implementation PlaylistsViewCtrl

@synthesize theTableView;
@synthesize playlists;
@synthesize addPlayListAlertView;
@synthesize playListObj;
@synthesize addSongToPlaylistView ;

-(void)showUserListDetail:(NSInteger)aID pName:(NSString *)aName
{
    NSMutableArray *theList =[playListObj getPlayListByID:aID];
    
    UserPlaylistDetailViewController *u =[[UserPlaylistDetailViewController alloc] init];
    u.thePlaylist = theList;
    u.plTitle = aName;
    u.pID =aID;
    
    [self.navigationController pushViewController:u animated:YES];
    [u release];
    
}
-(void)showListDetail:(NSInteger)aIndex
{
    NSArray *listInfo =[NSArray array];
    NSString *title =[NSString string];
    if (aIndex == 1) {
        listInfo =[playListObj getPlayList:kPlayListDefault];
        title =NSLocalizedString(@"Default", @"playlist default name");
    }else if(aIndex == 2){
        listInfo= [playListObj getPlayList:@"Title"];
        title = NSLocalizedString(@"Title", @"") ;
    }else if(aIndex ==3){
        listInfo =[playListObj recentlyPlayed];
        title = NSLocalizedString(@"Recently Played", @" ");
    }else if(aIndex ==4){
        listInfo =[playListObj recentlyAdded];
        title = NSLocalizedString(@"Recently Added", @" ");
    }
    
    DefaultPlaylistDetailViewController *d =[[DefaultPlaylistDetailViewController alloc] init];
    d.thePlaylist = listInfo ;
    d.plTitle =title;
    
    [self.navigationController pushViewController:d animated:YES];
    [d release];
    
}
-(void)initUserPlaylists
{
    if (self.playlists)
        self.playlists  =nil;
    NSMutableArray *l =    [[NSMutableArray alloc] init];
 
    [l addObject:[NSArray arrayWithObjects:NSLocalizedString(@"Add Playlist...", @" "), [NSNumber numberWithInt:kPlaylistCellAddlist],nil]];
 
    [l addObject:[NSArray arrayWithObjects:NSLocalizedString(@"Default", @"playlist default name"), [NSNumber numberWithInt:kPlaylistCellDefault],nil]];
 
    [l addObject:[NSArray arrayWithObjects:NSLocalizedString(@"Title", @""), [NSNumber numberWithInt:kPlaylistCellTitle],nil]];
 
    [l addObject:[NSArray arrayWithObjects:NSLocalizedString(@"Recently Played", @" "), [NSNumber numberWithInt:kPlaylistCellRecentlyPlayed],nil]];
    [l addObject:[NSArray arrayWithObjects:NSLocalizedString(@"Recently Added", @" "), [NSNumber numberWithInt:kPlaylistCellRecentlyAdded],nil]];
    [l addObjectsFromArray:[playListObj getPlaylists]];
    self.playlists = l;
    [l release];
    
}
-(void)showEditAlartView{
    //self.isShowAlert=YES; //boolean variable
    NSLocalizedString(@"New Playlist", @"New Playlist title");
    NSString *alertTitle =NSLocalizedString(@"New Playlist", @"New Playlist title");;
    
    //NSLocalizedString(@"Cancel", @"New Playlist title");
    //NSLocalizedString(@"Save", @"New Playlist title");
    
    UIAlertView *a =[[UIAlertView alloc] initWithTitle:alertTitle message:@"\n" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"")  otherButtonTitles:NSLocalizedString(@"Save", @""), nil];
    
    UITextField *txtName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 28.0)];
    
    txtName.placeholder =NSLocalizedString(@"Title", @"");
    [txtName setBorderStyle:UITextBorderStyleRoundedRect];
    [txtName setClearButtonMode:UITextFieldViewModeWhileEditing];
    [txtName setKeyboardAppearance:UIKeyboardAppearanceAlert];
    [txtName setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txtName setTextAlignment:UITextAlignmentLeft];
    txtName.tag =kAddPlaylistTextField;
    [txtName becomeFirstResponder];
    [a  addSubview:txtName];
    
    self.addPlayListAlertView =a ;
    [addPlayListAlertView show];
    
    [txtName release];
    [a release];
}

-(void)initUI
{
    UIView *contentView =[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view =contentView;
    contentView.backgroundColor =[UIColor whiteColor];
    //contentView.alpha =0.5;
    [contentView release];
    
    UITableView *t =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 436) style:UITableViewStylePlain];
    [t setDelegate:self];
    [t setDataSource:self];
    self.theTableView =t;
    [self.view addSubview:self.theTableView];
    [t release];
}
#pragma Mark - Class Base

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
    [theTableView release];
    [playlists release];
    [addPlayListAlertView release];
    [playListObj  release];
    [addSongToPlaylistView release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    
    self.title =NSLocalizedString(@"Playlists", @"playlist view title");
    
    
    //初始化应用程序委托
	//appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
    PlayList *p =[[PlayList alloc] init];
    self.playListObj =p;
    [p release];
    
    //[self initUserPlaylists];
    
    [self initUI];
    
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/
-(void)viewWillAppear:(BOOL)animated
{
    [self initUserPlaylists];
    if (self.theTableView) {
        [theTableView reloadData];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.theTableView = nil;
    self.playlists = nil ;
    self.addPlayListAlertView = nil;
    self.playListObj =nil;
    self.addSongToPlaylistView = nil ;
    
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
    return [playlists count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //----------
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
          
    }
    
    // Configure the cell...
    NSUInteger row =[indexPath row];
    NSArray *playlistName = [playlists objectAtIndex:row];
    cell.textLabel.text = [playlistName objectAtIndex:0];
    cell.tag = [[playlistName objectAtIndex:1] integerValue];
    if (cell.tag != kPlaylistCellAddlist) {
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    
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
    
    if (row == 0) {
        //ADD PLAYLIST...
        [self showEditAlartView];
    }else if(row > 4)
    {
        NSArray *aPlaylist = [playlists objectAtIndex:row];
       
        [self showUserListDetail:[[aPlaylist objectAtIndex:1] integerValue] pName:[aPlaylist objectAtIndex:0] ];
    }
    else {
        //def
        [self showListDetail:row];
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 42.0;
}

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //get save button
    if (buttonIndex == 1) {
        //NSLog(@"SAVE BUTTON!");
        //get text
        UITextField *textField =(UITextField *) [addPlayListAlertView viewWithTag:kAddPlaylistTextField];
        //save edit change
        NSString *newText =textField.text;
        //[self saveEditedSongInfo:newText forTitle:self.editAlertTitle];
        if (![newText isEqualToString:@""]) {
            NSInteger pid = [playListObj  savePlaylist:newText];
            [self initUserPlaylists];
            [theTableView reloadData];
            //NSLog(@"new playlist is:%@",newText);
            if (!self.addSongToPlaylistView) {
                AddSongToPlaylistViewController *a =[[AddSongToPlaylistViewController alloc] initWithNibName:@"AddSongToPlaylistView" bundle:nil] ;
                self.addSongToPlaylistView = a;
                [a release];
            }
            
            self.addSongToPlaylistView.listTitle = newText;
            self.addSongToPlaylistView.songsList =[playListObj getPlayList:kPlayListDefault];
            //[self.view addSubview:a.view ];
            //[a release];
            self.addSongToPlaylistView.pid = pid;
            self.addSongToPlaylistView.isPlaylistAddToThereSelf = NO;
            [self.addSongToPlaylistView.view setFrame:CGRectMake(0,480.0f, 320.0f, 460.0f)];
            
            //[self.favoritesView setDelegate:self];
            [self.tabBarController.view addSubview: self.addSongToPlaylistView.view];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [self.addSongToPlaylistView.view setFrame:CGRectMake(0,20.0f, 320.0f, 460.0f)];
            [UIView commitAnimations];
        } 
        
    }
}

@end
