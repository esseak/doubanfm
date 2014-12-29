//
//  SongViewModel.m
//  doubanfm
//
//  Created by Mike on 14/12/6.
//  Copyright (c) 2014年 hyz. All rights reserved.
//

#import "SongViewModel.h"

@implementation SongViewModel

-(void)updateView:(NSDictionary *)song{
    [self.artist setStringValue:[song objectForKey:@"artist"]];
    [self.title setStringValue:[song objectForKey:@"title"]];
    [self.albumtitle setStringValue:[NSString stringWithFormat:@"<%@> %@", [song objectForKey:@"albumtitle"],[song objectForKey:@"public_time"]]];
}
@end
