//
//  MyContentView.h
//  doubanfm
//
//  Created by Mike on 14/12/6.
//  Copyright (c) 2014年 hyz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol FMContentViewDelegate  <NSObject>

-(void)mouseEntered:(NSEvent *)theEvent;
-(void)mouseExited:(NSEvent *)theEvent;
-(void)mouseUp:(NSEvent *)theEvent;
-(void)contentViewClick:(id)sender;
-(NSWindow *)window;

@end

@interface FMContentView : NSView{
    NSPoint initialLocation;
    BOOL isDrag;
}
@property(weak,nonatomic) id<FMContentViewDelegate> delegete;
@end
