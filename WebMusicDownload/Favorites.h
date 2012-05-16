//
//  Favorites.h
//  WebMusicDownload
//
//  Created by Zen David on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserFavorites @"userFavorites"

@interface Favorites : NSObject {
    NSMutableDictionary *favoritesList;
    
}
@property (nonatomic,retain) NSMutableDictionary *favoritesList;

- (void)getFavorites;
- (void)saveFavorite:(NSString *) _url title:(NSString *) _title;
- (void)saveFavorites:(NSMutableDictionary *)bookmarks;
@end
