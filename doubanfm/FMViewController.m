//
//  ViewController.m
//  doubanfm
//
//  Created by Mike on 14/12/4.
//  Copyright (c) 2014年 hyz. All rights reserved.
//

#import "FMViewController.h"

@implementation FMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init UI
    
    NSColor *color = [NSColor whiteColor];
    NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self.miniBtn attributedTitle]];
    NSRange titleRange = NSMakeRange(0, [colorTitle length]);
    [colorTitle addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
    [self.miniBtn  setAttributedTitle:colorTitle];
    
    colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self.closeBtn attributedTitle]];
    titleRange = NSMakeRange(0, [colorTitle length]);
    [colorTitle addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
    [self.closeBtn  setAttributedTitle:colorTitle];
    
    

    
    
    self.privateQueue = dispatch_queue_create("com.mindsnacks.private_queue", DISPATCH_QUEUE_CONCURRENT);
    
    self.backgroundTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1
                                                                target:self
                                                              selector:@selector(backgroundTimerDidFire)
                                                              userInfo:nil
                                                               repeats:YES
                                                         dispatchQueue:self.privateQueue];
    
    self.player = [[STKAudioPlayer alloc] init];
    self.player.delegate = self;
    
    NSNumber *volumeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"_volume"];
    if(volumeValue == nil){
        volumeValue = [NSNumber numberWithFloat:0.5];
        [[NSUserDefaults standardUserDefaults]setObject:volumeValue forKey:@"_volume"];
    }
    
    self.player.volume =[volumeValue floatValue];
    self.volumeControl.floatValue  = [volumeValue floatValue]*100;
    
    
    self.progress = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 0, 5)];
    [self.progress setWantsLayer:YES];
    self.progress.layer.backgroundColor=[NSColor colorWithRed:45/255.0 green:146/255.0 blue:1 alpha:1].CGColor;
    
    [self.contentView addSubview:self.progress];
    [self.contentView addTrackingRect:NSMakeRect(0, 0, 250, 250) owner:self.contentView userData:nil assumeInside:YES];
    self.contentView.delegete = self;
    
    self.isNext = NO;
    
    [self requestNewSongs];
    
}

-(void)requestNewSongs{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://www.douban.com/j/app/radio/people?app_name=radio_desktop_win&version=100&type=n&channel=1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"operation: %@", operation.response);
        
        NSDictionary *jsonObject = (NSDictionary *)responseObject;
        
        NSArray *songs = [jsonObject objectForKey:@"song"];
        
        self.playList = [NSMutableArray arrayWithArray:songs];
        
        NSDictionary *song = [self.playList objectAtIndex:0];
        
        NSString *url =  [song objectForKey:@"url"];
        
        [self.player playURL:[NSURL URLWithString:url] withQueueItemID:song];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)onNextBtnClick:(id)sender {
    if(self.isNext) return;
    self.isNext = YES;
    
    [self.player stop];
    
    if(self.playList.count>0){
        NSDictionary *song =[self.playList objectAtIndex:0];
        NSString *url = [NSString stringWithFormat:@"http://www.douban.com/j/app/radio/people?app_name=radio_desktop_win&version=100&type=s&channel=1&sid=%@",[song objectForKey:@"sid"]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
            
            NSDictionary *jsonObject = (NSDictionary *)responseObject;
            
            NSArray *songs = [jsonObject objectForKey:@"song"];
            
            self.playList = [NSMutableArray arrayWithArray:songs];
            
            NSDictionary *song = [self.playList objectAtIndex:0];
            
            NSString *url =  [song objectForKey:@"url"];
            
            [self.player playURL:[NSURL URLWithString:url] withQueueItemID:song];
            
            self.isNext = NO;
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
    }
    



}
- (IBAction)onVolumeBtnClick:(NSButton *)sender {
    
    if(sender.state==1){
        [self.volumeControl setHidden:NO];
    }else{
        [self.volumeControl setHidden:YES];
    }
}


/// Raised when an item has started playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId{
    
    NSDictionary *song = (NSDictionary *)queueItemId;
    
    NSString *picture =  [song objectForKey:@"picture"];
    
    self.coverImageView.image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:picture]];
    
    self.title = [song objectForKey:@"title"];
    
    [self.songViewModel updateView:song];
    
    NSLog(@"didStartPlayingQueueItemId %@",queueItemId);
}
/// Raised when an item has finished buffering (may or may not be the currently playing item)
/// This event may be raised multiple times for the same item if seek is invoked on the player
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId{
    NSLog(@"didFinishBufferingSourceWithQueueItemId %@",queueItemId);
}
/// Raised when the state of the player has changed
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    
    NSLog(@"stateChanged state %d,previousState %d",state,previousState);
    
}
/// Raised when an item has finished playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration{
    
    
    if (self.isNext) {
        
    }else{
        
        [self.playList removeObjectAtIndex:0];
        
        if(self.playList.count == 0){
            [self requestNewSongs];
        }else{
            NSDictionary *song = [self.playList objectAtIndex:0];
            
            NSString *url =  [song objectForKey:@"url"];
            
            [self.player playURL:[NSURL URLWithString:url] withQueueItemID:song];
        }
       
    }
    
    
    
     NSLog(@"didFinishPlayingQueueItemId queueItemId %@,withReason %d,andProgress %f,andDuration %f",queueItemId,stopReason,progress,duration);
}
/// Raised when an unexpected and possibly unrecoverable error has occured (usually best to recreate the STKAudioPlauyer)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode{
    NSLog(@"unexpectedError %d",errorCode);
}

/// Optionally implemented to get logging information from the STKAudioPlayer (used internally for debugging)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer logInfo:(NSString*)line{
    NSLog(@"logInfo %@",line);
}
/// Raised when items queued items are cleared (usually because of a call to play, setDataSource or stop)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didCancelQueuedItems:(NSArray*)queuedItems{
    NSLog(@"didCancelQueuedItems %@",queuedItems);
}

- (void)backgroundTimerDidFire
{
    //NSLog(@"progress %f,duration %f,",[self.player progress],[self.player duration]);
    if(self.player.state==STKAudioPlayerStatePlaying && self.player.duration>0.0){
        dispatch_async(dispatch_get_main_queue(), ^{
        double progressValue = 250*[self.player progress]/[self.player duration];
        if (progressValue<=250.0) {
            [self.progress setFrameSize:NSMakeSize(250*[self.player progress]/[self.player duration], 5)];
        }
        });
    }
}

-(void)mouseEntered:(NSEvent *)theEvent{
    [self.coverView setHidden:NO];
}
-(void)mouseExited:(NSEvent *)theEvent{
    [self.coverView setHidden:YES];
    
    if(!self.volumeControl.isHidden)
        [self.volumeControl setHidden:YES];
    
    self.volumeBtn.state = 0;
}

-(void)mouseUp:(NSEvent *)theEvent{

}
-(NSWindow *)window{
    return  [[NSApplication sharedApplication].windows objectAtIndex:0];
}

-(void)contentViewClick:(id)sender{
    if(!self.volumeControl.isHidden)
        [self.volumeControl setHidden:YES];
    self.volumeBtn.state = 0;
}

- (IBAction)onMiniBtnClick:(NSButton *)sender {
    [[NSApplication sharedApplication]hide:nil];
}

- (IBAction)onCloseBtnClick:(NSButton *)sender {

}

- (IBAction)onPlayBtnClick:(NSButton *)sender {
    
    if(sender.state==1){
        [self.player pause];
        
        [sender setImage:[NSImage imageNamed:@"play"]];
        [sender setAlternateImage:[NSImage imageNamed:@"play_on"]];
    }else{
        [self.player resume];
        [sender setImage:[NSImage imageNamed:@"pause"]];
        [sender setAlternateImage:[NSImage imageNamed:@"pause_on"]];
    }
    
}
- (IBAction)onVolumeChange:(NSSlider *)sender{

    self.player.volume = [sender floatValue]/100;
    NSNumber *volumeValue = [NSNumber numberWithFloat:[sender floatValue]/100];
    [[NSUserDefaults standardUserDefaults]setObject:volumeValue forKey:@"_volume"];
    
}
@end
