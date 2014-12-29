//
//  ViewController.h
//  doubanfm
//
//  Created by Mike on 14/12/4.
//  Copyright (c) 2014年 hyz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AFNetworking.h"
#import "STKAudioPlayer.h"
#import "MSWeakTimer.h"
#import "FMCoverView.h"
#import "FMContentView.h"
#import "SongViewModel.h"

@interface FMViewController : NSViewController <STKAudioPlayerDelegate,FMContentViewDelegate>
@property (weak) IBOutlet NSImageView *coverImageView;
@property (strong)  STKAudioPlayer *player;
@property (strong) NSMutableArray *playList;
@property (strong, nonatomic) dispatch_queue_t privateQueue;
@property (strong, nonatomic) MSWeakTimer *backgroundTimer;
@property (strong, nonatomic) NSView *progress;
@property (strong) IBOutlet FMContentView *contentView;
@property (weak) IBOutlet FMCoverView *coverView;
@property (assign,nonatomic) BOOL isNext;

@property (strong) IBOutlet SongViewModel *songViewModel;
@property (weak) IBOutlet NSSlider *volumeControl;
@property (weak) IBOutlet NSButton *volumeBtn;
@property (weak) IBOutlet NSButton *playBtn;

@property (weak) IBOutlet NSButton *closeBtn;
@property (weak) IBOutlet NSButton *miniBtn;
- (IBAction)onMiniBtnClick:(NSButton *)sender;
- (IBAction)onCloseBtnClick:(NSButton *)sender;
- (IBAction)onPlayBtnClick:(NSButton *)sender;
- (IBAction)onVolumeChange:(NSSlider *)sender;


@end

