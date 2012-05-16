//
//  MySqlite.m
//  WebMusicDownload
//
//  Created by Zen David on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MySqlite.h"



@implementation MySqlite

@synthesize  db;
@synthesize  DBPath;

- (id)init
{
	
    self = [super init];
    if (self) {
        /* class-specific initialization goes here */
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if(![fileManager fileExistsAtPath:[self getDBPath]]){
			[self resetDBS];
		}
		self.DBPath =[self getDBPath];
    }
    return self;
}// end init



-(void)resetDBS{
	//creative file to doc path
	// delete the old db.
	self.DBPath =[self getDBPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:DBPath error:nil];
	FMDatabase *_db = [[FMDatabase alloc] initWithPath:DBPath];
    self.db =_db;
    [_db release];
    
	if (![self.db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
	//[self.db setShouldCacheStatements:YES];
	
	//creative tables
    [self.db executeUpdate:@"PRAGMA encoding ='UTF8';"];
    [self.db executeUpdate:@"CREATE TABLE task_list (fid INTEGER PRIMARY KEY AUTOINCREMENT,url TEXT, task_status TEXT, save_path TEXT , progress REAL ,display_name TEXT,file_size INTEGER ,album_name TEXT, title TEXT, duration INTEGER,artist TEXT,song_type TEXT);"];
    [self.db executeUpdate:@"CREATE TABLE playlist_name (pid INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT);"];
    [self.db executeUpdate:@"CREATE TABLE playlist (id INTEGER PRIMARY KEY AUTOINCREMENT,pid INTEGER, fid INTEGER);"];
    
	[self.db close];
    
}
-(void)openDB{
    FMDatabase *_db = [[FMDatabase alloc] initWithPath:DBPath];
    self.db =_db;
    [_db release];
	if (![self.db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    //[db setShouldCacheStatements:YES];
}//end


-(NSString *)getDBPath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *defaultDBPath = [documentsDirectoryPath stringByAppendingPathComponent:kDBFileName];
	return defaultDBPath;
}//end

-(void)dealloc{
	[DBPath release];
	[db release];
    
	[super dealloc];
}

@end
