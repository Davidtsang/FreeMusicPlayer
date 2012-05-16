//
//  SongInfoViewController.m
//  WebMusicDownload
//
//  Created by Zen David on 11-8-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SongInfoViewController.h"
#import "MyFunction.h"


@interface SongInfoViewController()
@property(nonatomic,assign)BOOL isShowAlert;
@property(nonatomic,retain)UIAlertView *editAlertView;
@property(nonatomic,retain)NSString *editAlertTitle;

-(void)getSongInfo:(NSInteger)songID;
-(void)showEditAlartView:(NSArray *)cellItem;
-(void)saveEditedSongInfo:(NSString *)newText forTitle:(NSString *)theTitle;

@end
//-----privave end

@implementation SongInfoViewController
@synthesize thisTableView;
@synthesize songInfo;
@synthesize songID;
@synthesize isShowAlert;
@synthesize editAlertView;
@synthesize editAlertTitle;

-(void)saveEditedSongInfo:(NSString *)newText forTitle:(NSString *)theTitle
{
    NSString *theSqlKey =[NSString string];
    if ([theTitle isEqualToString:@"Title"]) {
        theSqlKey = @"title";
    }else if([theTitle isEqualToString:@"Artist"])
    {
        theSqlKey =@"artist";
    }else if ([theTitle isEqualToString:@"Album"]){
        theSqlKey =@"album_name";
    }else if([theTitle isEqualToString:@"Type"]){
        theSqlKey =@"song_type";
    }
    //save to db
    NSString *theSQL =[NSString stringWithFormat:@"UPDATE task_list SET  %@ = ? WHERE fid =?;",theSqlKey];
    [appDelegate.mysqlite.db executeUpdate:theSQL,
     newText,
     [NSNumber numberWithInteger:self.songID]
     ];
    
    if ([appDelegate.mysqlite.db  hadError]) {
        NSLog(@"-(void)saveEditedSongInfo:(NSString *)newText forTitle:(NSString *)theTitle->db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }

}
-(void)showEditAlartView:(NSArray *)cellItem{
    self.isShowAlert=YES; //boolean variable
    NSString *theTitle =[cellItem objectAtIndex:0];
    NSString *theValue =[cellItem objectAtIndex:1];
    NSString *alertTitle =[NSString stringWithFormat:@"Edit %@",theTitle];
    self.editAlertTitle =theTitle;
    
    UIAlertView *a_ = [[UIAlertView alloc] initWithTitle:alertTitle message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    self.editAlertView =a_;
    [a_ release];
    
    UITextField *txtName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 28.0)];
    txtName.text=theValue;
    //[txtName setBackgroundColor:[UIColor whiteColor]];
    [txtName setBorderStyle:UITextBorderStyleRoundedRect];
    [txtName setClearButtonMode:UITextFieldViewModeWhileEditing];
    [txtName setKeyboardAppearance:UIKeyboardAppearanceAlert];
    [txtName setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txtName setTextAlignment:UITextAlignmentLeft];
    txtName.tag =kEditAlartTextField;
    
    [editAlertView addSubview:txtName];
    [txtName release];
    [editAlertView show];
}

-(void)getSongInfo:(NSInteger)theSongID
{

    
    
    //    Title|title
    //    Album|albumName
    //    Artist|artist
    //    Type|type
    //    --------------
    //    Duration|
    //    Size|
    //    URL|
    //    FileName|
    NSArray *_songInfo;
    FMResultSet *rs =[appDelegate.mysqlite.db executeQuery:@"SELECT  url , display_name,file_size ,album_name,title,duration,artist ,song_type FROM task_list WHERE fid =?;" ,[NSNumber numberWithInteger:theSongID]];
    if ([appDelegate.mysqlite.db hadError]) {
        NSLog(@"- (void)getAllItemsFromDBS-> db Error :%@",[appDelegate.mysqlite.db lastErrorMessage]);
    }

	if ([rs next]) {
        //NSInteger iFid = [rs intForColumn:@"fid"];
        NSString *taskUrl = [rs stringForColumn:@"url"];
        NSString *taskName =[rs stringForColumn:@"display_name"];
        
        NSString *albumName =[rs stringForColumn:@"album_name"];
        //if (albumName ==NULL)  albumName = @"";
 
        NSString *songTitle =[rs stringForColumn:@"title"];
        //if (songTitle ==NULL)  songTitle = @"";
        
        NSInteger iDuration = [rs intForColumn:@"duration"];
        
        NSString *songArtist =[rs stringForColumn:@"artist"];
        //if (songArtist ==NULL) songArtist = @"";
        
        NSString *songType =[rs stringForColumn:@"song_type"];
        //if (songType ==NULL) songType = @"";
        
        NSInteger iFile_size = [rs intForColumn:@"file_size"];
        NSString *fileSize = [MyFunction stringFromFileSize:iFile_size];
        
        _songInfo =[[NSArray alloc] initWithObjects:
                    [NSArray arrayWithObjects:@"Title",songTitle, [NSNumber numberWithBool:YES], nil] ,
                    [NSArray arrayWithObjects:@"Artist",songArtist, [NSNumber numberWithBool:YES],nil] ,
                    [NSArray arrayWithObjects:@"Album",albumName, [NSNumber numberWithBool:YES],nil] ,
                    [NSArray arrayWithObjects:@"Type",songType, [NSNumber numberWithBool:YES],nil] ,
                    [NSArray arrayWithObjects:@"Duration",[MyFunction convertTimeFromSeconds:iDuration] , [NSNumber numberWithBool:NO],nil] ,
                    [NSArray arrayWithObjects:@"FileName",taskName, [NSNumber numberWithBool:NO],nil] ,
                    [NSArray arrayWithObjects:@"URL",taskUrl, [NSNumber numberWithBool:NO],nil] ,
                    [NSArray arrayWithObjects:@"Size",fileSize,[NSNumber numberWithBool:NO], nil] ,
                    
                    nil];
        self.songInfo =[NSMutableArray arrayWithArray:_songInfo];
        [_songInfo release];
    }
    [rs close];
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
    [songInfo release];
    [thisTableView release];
    [editAlertView release];
    [editAlertTitle release];
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
    self.title = @"Song Info";
    
    //read info from dbs
   appDelegate =(WebMusicDownloadAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self getSongInfo:self.songID];
    
}

- (void)viewDidUnload
{
    self.thisTableView =nil;
    self.songInfo =nil;
    self.editAlertView =nil;
    self.editAlertTitle =nil;
    
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
    return [songInfo count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
  
        
    }
    
    // Configure the cell...
    NSUInteger row =[indexPath row];
    NSArray *cellInfo = [songInfo objectAtIndex:row];
    cell.textLabel.text =[cellInfo objectAtIndex:0];
    cell.detailTextLabel.font =[UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = [cellInfo objectAtIndex:1];
    cell.userInteractionEnabled =[[cellInfo objectAtIndex:2] boolValue];
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Properties:";
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"You can change the Title, Artist, Album and Type by tapping on them.";
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
 
    //darw a cell
    [self showEditAlartView:[songInfo objectAtIndex:row]];
    //name: state
    //url 
    //pro
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //get save button
    if (buttonIndex == 1) {
        //NSLog(@"SAVE BUTTON!");
        //get text
        UITextField *textField =(UITextField *) [editAlertView viewWithTag:kEditAlartTextField];
        //save edit change
        NSString *newText =textField.text;
        [self saveEditedSongInfo:newText forTitle:self.editAlertTitle];
        [self getSongInfo:self.songID];
        [thisTableView reloadData];
        
    }
}
@end
