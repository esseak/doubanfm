//
//  SongViewModel.h
//  doubanfm
//
//  Created by Mike on 14/12/6.
//  Copyright (c) 2014年 hyz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface SongViewModel : NSObject
@property (weak) IBOutlet NSTextField *title;
@property (weak) IBOutlet NSTextField *artist;
@property (weak) IBOutlet NSTextField *albumtitle;

-(void)updateView:(NSDictionary *)song;
@end
