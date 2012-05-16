//
//  MySqlite.h
//  WebMusicDownload
//
//  Created by Zen David on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

#define kDBFileName @"data.sqlite3"


@interface MySqlite : NSObject {
    FMDatabase *db;
	NSString *DBPath;
}

@property(nonatomic,retain)FMDatabase *db;
@property(nonatomic,retain)NSString *DBPath;
//reset db system
-(NSString *)getDBPath;
-(void)resetDBS;
-(void)openDB;

@end
