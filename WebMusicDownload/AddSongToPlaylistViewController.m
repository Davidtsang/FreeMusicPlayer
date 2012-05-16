//
//  AddSongToPlaylistViewController.m
//  WebMusicDownload
//
//  Created by Zen David on 11-10-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AddSongToPlaylistViewController.h"
#import "PlayList.h"
#import "UserPlaylistDetailViewController.h"
#import "WebMusicDownloadAppDelegate.h"

@implementation AddSongToPlaylistViewController
//

@synthesize thisTableView;
@synthesize navBar;
@synthesize navItem ;
@synthesize songsList;
@synthesize selectedSongs ;
@synthesize playlistOBJ;
@synthesize listTitle;
@synthesize pid;
@synthesize isPlaylistAddToThereSelf;
//

- (id)delegate
{
    return delegate;
}
- (void)setDelegate:(id)aDelegate
{
    delegate = aDelegate;
}

-(void)doRemoveFromSuperview
{
    [self.view removeFromSuperview];
}
-(void)toDone
{
    if (self.playlistOBJ ==nil) {
        PlayList *p =[[PlayList alloc] init];
        self.playlistOBJ =p ;
        [p release];
        
    }
    if ([selectedSongs count] > 0 )
    {
        //[playlistOBJ saveThePlaylistByName:self.selectedSongs withName:self.listTitle];
        if (!playlistOBJ) {
            PlayList *p =[[PlayList alloc] init];
            self.playlistOBJ =p;
            [p release];
        }
        [playlistOBJ saveThePlaylistByName:self.selectedSongs withPID:self.pid];
    }
    //[self.addSongToPlaylistView.view setFrame:CGRectMake(0,480.0f, 320.0f, 460.0f)];
    
    
    //[self.tabBarController.view addSubview: self.addSongToPlaylistView.view];
    if (isPlaylistAddToThereSelf == NO) {
        UserPlaylistDetailViewController *u = [[UserPlaylistDetailViewController alloc] init];
        u.plTitle = self.listTitle;
        u.thePlaylist =[playlistOBJ getPlayListByID:self.pid];
        u.pID =self.pid;
        
        [appDelegate.playerNavigation pushViewController:u animated:NO];
        [u release];
    }
    if ([delegate respondsToSelector:@selector(renewTable)]) 
    {
        [delegate performSelector:@selector(renewTable)];
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(doRemoveFromSuperview)];
    [self.view setFrame:CGRectMake(0,480.0f, 320.0f, 480.0f)];
    [UIView commitAnimations];

}//end function

-(void)toAddSong:(id)sender
{
    UITableViewCell *theCell =(UITableViewCell *)[sender superview];
    //NSLog(@"cell.tag is:%d",theCell.tag);
    NSNumber *songID =[NSNumber numberWithInteger:theCell.tag];
    [self addSelectedSongBySID:songID];
    theCell.textLabel.textColor = [UIColor grayColor];
    theCell.detailTextLabel.textColor = [UIColor grayColor];
}//end fun

-(void)addSelectedSongBySID:(NSNumber* )songID
{
    if (!self.selectedSongs) {
        NSMutableArray *s =[[NSMutableArray alloc] init];
        self.selectedSongs = s;
        [s release];
    }

    BOOL isSIDExist =NO;
    if ([self.selectedSongs count]> 0) {
        for (NSNumber *aSongID in selectedSongs)
        {
            if ([aSongID isEqualToNumber:songID])
            {
                isSIDExist =YES;
            }
        }
    }
    
    if (isSIDExist == NO) {
        [selectedSongs addObject:songID];
    }
}

#pragma  mark - Class Base

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
    [navBar release];
    [navItem release];
    [songsList release];
    [selectedSongs release];
    [playlistOBJ release];
    [listTitle release];
    
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

    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toDone)] autorelease];
	self.navItem.rightBarButtonItem =doneButton;	
    self.navItem.prompt =[NSString stringWithFormat:@"%@ %@.",self.navItem.prompt, self.listTitle];
    
    //初始化应用程序委托
	appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.thisTableView = nil;
    self.navBar  = nil;
    self.navItem = nil ;
    self.songsList = nil ;
    self.selectedSongs = nil ;
    self.playlistOBJ = nil;
    self.listTitle = nil;
    
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

    return [songsList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //----------
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];

    }
    
    // Configure the cell...
    NSUInteger row =[indexPath row];
    NSMutableDictionary *theSong =[songsList objectAtIndex:row];
    
    UIImage *image = [UIImage imageNamed:@"blue_plus.png"];
    UIImage *imagePressed = [UIImage imageNamed:@"blue_plus_pressed.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
 
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);

    //match the button's size with the image size
    button.frame = frame;
        
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
    
    // set the button's target to this table view controller so you can open the next view
    [button addTarget:self action:@selector(toAddSong:) forControlEvents:UIControlEventTouchUpInside];
        
    button.backgroundColor = [UIColor clearColor];
    
    cell.accessoryView = button;
    NSNumber *sid =[theSong objectForKey:kSongID];
    cell.tag =[sid intValue];
    cell.textLabel.text =[theSong objectForKey:kSongTitle];
    cell.detailTextLabel.text =[theSong objectForKey:kSongAlbum];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = nil ;
    
    if ([selectedSongs count]>0) {
        for (NSNumber *aSongID in self.selectedSongs) {
            if ([aSongID isEqualToNumber:sid]) {
                cell.textLabel.textColor = [UIColor grayColor];
                cell.detailTextLabel.textColor = [UIColor grayColor];
            }
        }//for
    }//if
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
    //FOR ROW GET SONG
    NSMutableDictionary *theSong =[songsList objectAtIndex:row];
    //ADD SONG TO SELCEED
    NSNumber *songID =[theSong objectForKey:kSongID];
    [self addSelectedSongBySID:songID];
    [thisTableView reloadData];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

@end
