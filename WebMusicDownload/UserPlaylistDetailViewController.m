//
//  UserPlaylistDetailViewController.m
//  WebMusicDownload
//
//  Created by Zen David on 11-10-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserPlaylistDetailViewController.h"
#import "PlayList.h"
#import "NowPlayingViewController.h"
#import "AddSongToPlaylistViewController.h"

#define kStdButtonH 33
#define kStdButtonW 99
#define KStdButtonTop 5
#define kUPlistFontSize 18
#define kActionTypeClean @"Clear Playlist"
#define kActionTypeDelete @"Delete Playlist"

@interface UserPlaylistDetailViewController()

@property(nonatomic,retain)UITableView *theTableView;
@property(nonatomic,retain) PlayList *playlistObj;
@property(nonatomic,retain) UIBarButtonItem *leftNavBtn;
@property(nonatomic,assign) BOOL isInEditing;
@property(nonatomic,retain) NSString *actionSheetType;
@property(nonatomic,retain)AddSongToPlaylistViewController *addSongToPlaylistView;

-(void)initUI;
-(void)donePressed:(id)sender;
-(void)editPressed:(id)sender;
-(void)cleanPressed ;
-(void)doClean;
-(void)deletePressed ;
-(void)doDelete;
-(void)placeStdButton:(UITableViewCell*)cell;
-(void)renewTable;
-(void)placeDoneButton:(UITableViewCell*)cell;

@end

@implementation UserPlaylistDetailViewController
@synthesize plTitle;
@synthesize thePlaylist;
@synthesize theTableView;
@synthesize isInEditing;
@synthesize pID;
@synthesize playlistObj;
@synthesize leftNavBtn;
@synthesize actionSheetType;
@synthesize addSongToPlaylistView;

#pragma mark -
-(void)renewTable
{
    //load at plist
    self.thePlaylist =[playlistObj getPlayListByID:self.pID];
    [theTableView reloadData];
    
}
- (void)popConfirmSheet:(NSString *)aType
{
    //self.sheetSelectTempURL =urlString;
    //NSString *sheetTitle =[NSString stringWithFormat:@"Select action for the link: %@",urlString];
    self.actionSheetType = aType;
    //UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:aTitel];
    UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:self.actionSheetType otherButtonTitles:nil ];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}


-(void)addPressed:(id)sender
{
    //show add song view
    if (!self.addSongToPlaylistView) {
        AddSongToPlaylistViewController *a =[[AddSongToPlaylistViewController alloc] initWithNibName:@"AddSongToPlaylistView" bundle:nil] ;
        self.addSongToPlaylistView = a;
        [a release];
    }
    
    self.addSongToPlaylistView.listTitle = self.plTitle;
    self.addSongToPlaylistView.songsList =[playlistObj getPlayList:kPlayListDefault];
    self.addSongToPlaylistView.selectedSongs = nil;
    self.addSongToPlaylistView.pid = self.pID;
    self.addSongToPlaylistView.isPlaylistAddToThereSelf =YES;
    [addSongToPlaylistView setDelegate:self];
    [self.addSongToPlaylistView.view setFrame:CGRectMake(0,480.0f, 320.0f, 460.0f)];
    
    //[self.favoritesView setDelegate:self];
    [self.tabBarController.view addSubview: self.addSongToPlaylistView.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [self.addSongToPlaylistView.view setFrame:CGRectMake(0,20.0f, 320.0f, 460.0f)];
    [UIView commitAnimations];
}
-(void)donePressed:(id)sender
{
    [theTableView setEditing:NO animated:YES];
    
    //remove done button
    UITableViewCell *cell =(UITableViewCell *)[[sender superview] superview];
    
    //-clean cell butoon
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }

    //add
    [self placeStdButton:cell];
    //nav item
    self.navigationItem.leftBarButtonItem =self.leftNavBtn ;
    self.isInEditing =NO;
}
-(void)placeDoneButton:(UITableViewCell*)cell
{
    //add done button
    CGRect doneBtnRect =  CGRectMake(40.0, KStdButtonTop, 240.0, kStdButtonH);
    // Create a button and add as subview to cell
    // Get coordinates to place the button
    
    UIButton *doneButton    = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    [doneButton setFrame:doneBtnRect ];
    doneButton.titleLabel.font              = [UIFont boldSystemFontOfSize:kUPlistFontSize];
    //button.titleLabel.lineBreakMode     = UILineBreakModeTailTruncation;
    //editButton.titleLabel.shadowColor =[UIColor whiteColor];
    doneButton.titleLabel.shadowOffset =CGSizeMake(0, 1);
    [doneButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    UIImage *geryImage = [UIImage imageNamed:@"grey_button_normal.png"];
    UIImage *geryButtonImage = [geryImage stretchableImageWithLeftCapWidth:8 topCapHeight:0];
    [doneButton setBackgroundImage:geryButtonImage forState:UIControlStateNormal];
    [doneButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *geryImagePressed = [UIImage imageNamed:@"grey_button_normal_pressed.png"];
    UIImage *geryButtonImagePressed = [geryImagePressed stretchableImageWithLeftCapWidth:8 topCapHeight:0];
    [doneButton setBackgroundImage:geryButtonImagePressed forState:UIControlStateHighlighted];
    
    doneButton.contentVerticalAlignment     = UIControlContentVerticalAlignmentCenter;
    doneButton.contentHorizontalAlignment   = UIControlContentHorizontalAlignmentCenter;
    
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:doneButton];

}
-(void)editPressed:(id)sender
{
    // tabel enter edit states
    self.isInEditing =YES;
    [self.theTableView setEditing:YES animated:YES];
    //0 row  trun Done button
    //-get cell
    UITableViewCell *cell =(UITableViewCell *)[[sender superview] superview];
   
    //-clean cell butoon
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    [self placeDoneButton:cell];
    
    //add + button + navbar
    //UIBarButtonSystemItemAdd
    UIBarButtonItem *addBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed:)];
    self.navigationItem.leftBarButtonItem = addBtn;
    [addBtn release];
       

}
-(void)cleanPressed 
{
    [self popConfirmSheet:kActionTypeClean];
}
-(void)doClean
{
    //clean playlist
    [playlistObj cleanPlaylist:self.pID];
    //reload table
    self.thePlaylist = nil ;
    [self.theTableView reloadData];
}

-(void)deletePressed 
{
    [self popConfirmSheet:kActionTypeDelete];
    
}

-(void)doDelete 
{
    //clean playlist
    [playlistObj cleanPlaylist:self.pID];
    //delete palylistname
    [playlistObj deletePlaylist:self.pID];
    //pop view
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)placeStdButton:(UITableViewCell*)cell
{
  
    CGRect editBtnRect =  CGRectMake(5, KStdButtonTop, kStdButtonW, kStdButtonH);
    CGRect cleanBtnRect =  CGRectMake(110, KStdButtonTop, kStdButtonW, kStdButtonH);
    CGRect deleteBtnRect =  CGRectMake(215, KStdButtonTop, kStdButtonW, kStdButtonH);
        // Create a button and add as subview to cell
    // Get coordinates to place the button
    
    UIButton *editButton    =  [UIButton buttonWithType:UIButtonTypeRoundedRect]  ;
    [editButton setFrame:editBtnRect ];
    editButton.titleLabel.font              = [UIFont boldSystemFontOfSize:kUPlistFontSize];
    //button.titleLabel.lineBreakMode     = UILineBreakModeTailTruncation;
    //editButton.titleLabel.shadowColor =[UIColor whiteColor];
    editButton.titleLabel.shadowOffset =CGSizeMake(0, 1);
    [editButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    UIImage *geryImage = [UIImage imageNamed:@"grey_button_normal.png"];
    UIImage *geryButtonImage = [geryImage stretchableImageWithLeftCapWidth:8 topCapHeight:0];
    [editButton setBackgroundImage:geryButtonImage forState:UIControlStateNormal];
    [editButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *geryImagePressed = [UIImage imageNamed:@"grey_button_normal_pressed.png"];
    UIImage *geryButtonImagePressed = [geryImagePressed stretchableImageWithLeftCapWidth:8 topCapHeight:0];
    [editButton setBackgroundImage:geryButtonImagePressed forState:UIControlStateHighlighted];
    
    editButton.contentVerticalAlignment     = UIControlContentVerticalAlignmentCenter;
    editButton.contentHorizontalAlignment   = UIControlContentHorizontalAlignmentCenter;
    
    [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:editButton];
 
    UIButton *cleanButton    =  [UIButton buttonWithType:UIButtonTypeRoundedRect]  ;
    [cleanButton setFrame:cleanBtnRect ];
    cleanButton.titleLabel.font              = [UIFont boldSystemFontOfSize:kUPlistFontSize];
    //button.titleLabel.lineBreakMode     = UILineBreakModeTailTruncation;
    //cleanButton.titleLabel.shadowColor =[UIColor whiteColor];
    cleanButton.titleLabel.shadowOffset =CGSizeMake(0, 1);
    [cleanButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cleanButton setBackgroundImage:geryButtonImage forState:UIControlStateNormal];
    [cleanButton setBackgroundImage:geryButtonImagePressed forState:UIControlStateHighlighted];
    [cleanButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cleanButton.contentVerticalAlignment     = UIControlContentVerticalAlignmentCenter;
    cleanButton.contentHorizontalAlignment   = UIControlContentHorizontalAlignmentCenter;
    
    [cleanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cleanButton setTitle:@"Clean" forState:UIControlStateNormal];
    [cleanButton addTarget:self action:@selector(cleanPressed) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cleanButton]; 
    
    UIButton *deleteButton    =  [UIButton buttonWithType:UIButtonTypeRoundedRect]  ;
    [deleteButton setFrame:deleteBtnRect ];
    deleteButton.titleLabel.font              = [UIFont boldSystemFontOfSize:kUPlistFontSize];
    //button.titleLabel.lineBreakMode     = UILineBreakModeTailTruncation;
    //deleteButton.titleLabel.shadowColor =[UIColor whiteColor];
    deleteButton.titleLabel.shadowOffset =CGSizeMake(0, 1);
    [deleteButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [deleteButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:geryButtonImage forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:geryButtonImagePressed forState:UIControlStateHighlighted];
    
    deleteButton.contentVerticalAlignment     = UIControlContentVerticalAlignmentCenter;
    deleteButton.contentHorizontalAlignment   = UIControlContentHorizontalAlignmentCenter;
    
    [deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deletePressed) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:deleteButton];  
    
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
    [plTitle release];
    [thePlaylist release];
    [theTableView release];
    [playlistObj release];
    [leftNavBtn release];
    [actionSheetType release];
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
    self.isInEditing =NO;
    [self initUI];
    self.title = self.plTitle;
    
    PlayList *p =[[PlayList alloc] init];
    self.playlistObj = p;
    [p release];
    
    self.leftNavBtn = [self.navigationItem.leftBarButtonItem copy];
    
}
//
//-(void)viewWillAppear:(BOOL)animated
//{
//    NSLog(@"view show...");
//    [self renewTable];
//}
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.plTitle =nil;
    self.thePlaylist = nil ;
    self.theTableView = nil;
    self.playlistObj =nil;
    self.leftNavBtn = nil ;
    self.actionSheetType = nil;
    self.addSongToPlaylistView  = nil;
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

    return [thePlaylist count]+1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row =[indexPath row];
    UITableViewCell *cell;
    //----------
     if (row != 0) {
        static NSString *CellIdentifier = @"Cell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
        //----------
        NSMutableDictionary *aSong = [thePlaylist objectAtIndex:row-1];
        cell.textLabel.text =[aSong objectForKey:kSongTitle];
        cell.detailTextLabel.text =[aSong objectForKey:kSongAlbum];
        cell.tag =[[aSong objectForKey:kSongID] intValue];
    }else{
        static NSString *CellIdentifier = @"CellHeader";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }

        //-clean cell butoon
        if ([cell.contentView subviews]){
            for (UIView *subview in [cell.contentView subviews]) {
                [subview removeFromSuperview];
            }
        }
        
        if (self.isInEditing == YES) {
            [self placeDoneButton:cell];
        }else{
            [self placeStdButton:cell];
        }
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
    
    //GET NOWPLAYIN REF
    NSArray* views = [self.navigationController viewControllers];
    NowPlayingViewController *nowPlayingView =(NowPlayingViewController *)[views objectAtIndex:1];
    nowPlayingView.playList = [NSMutableArray arrayWithArray:self.thePlaylist];
    nowPlayingView.currentPlayingIndex =row-1;
    [nowPlayingView initPlaylist];
    //SET PLAYLIST
    //SET INDEX
    //PUST TO NOWPLAYING
    [self.navigationController popToViewController:nowPlayingView animated:YES];
    [nowPlayingView updataAll];
    [nowPlayingView stdPlaySongAction:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger row =[indexPath row]-1;
    //DEL ITEM
    NSMutableDictionary *theSong =[thePlaylist objectAtIndex:row];
    
    NSInteger needDelSongSID = [[theSong objectForKey:kSongID] integerValue];
    [self.thePlaylist removeObjectAtIndex:row];
        
    //SAVE
    //[playlistObj saveThePlaylistByName:self.selectedSongs withPID:self.pid];
    [playlistObj delSongFromPlaylistBySID:needDelSongSID thePlaylistID:self.pID];
    //reload
    [self.theTableView reloadData];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

#pragma mark - ActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0){
        if (self.actionSheetType ==kActionTypeClean) {
            [self doClean];
        }else if(self.actionSheetType == kActionTypeDelete){
            [self doDelete];
        }
    }//end if
    
}


@end
