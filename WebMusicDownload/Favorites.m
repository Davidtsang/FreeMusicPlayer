//
//  Favorites.m
//  WebMusicDownload
//
//  Created by Zen David on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Favorites.h"


@implementation Favorites
@synthesize favoritesList;

-(id)init
{
    self = [super init];
    if (self) {  
    
    //init code
    self.favoritesList =[NSMutableDictionary dictionary];
    [self getFavorites];
	}
    return self;
}

- (void)getFavorites
{
    NSMutableDictionary* userFavorites =[NSMutableDictionary dictionaryWithDictionary:
                                         [[NSUserDefaults standardUserDefaults] dictionaryForKey:kUserFavorites] 
                                         ];
    
    self.favoritesList =userFavorites;

}//
- (void)saveFavorites:(NSMutableDictionary *)bookmarks{
    [[NSUserDefaults standardUserDefaults] setObject:bookmarks 
                                              forKey:kUserFavorites];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

- (void)saveFavorite:(NSString *) _url title:(NSString *) _title
{
    //test:
    if ([_title isEqualToString:@""]) {
        _title = _url;
    }
    //NSLog(@"title:%@,url: %@",_url,_title);
    
  	[self.favoritesList setObject:_title forKey:_url];
    
    //test:
    //NSLog(@"title:%@ ",[self.favoritesList objectForKey:_url ]);
    
    [[NSUserDefaults standardUserDefaults] setObject:self.favoritesList 
                                              forKey:kUserFavorites];
    [[NSUserDefaults standardUserDefaults] synchronize]; 

}

- (void)dealloc{
    
    [favoritesList release];
    [super dealloc];
    
}


@end
