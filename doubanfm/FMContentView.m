//
//  FMContentView.m
//  doubanfm
//
//  Created by Mike on 14/12/6.
//  Copyright (c) 2014年 hyz. All rights reserved.
//

#import "FMContentView.h"

@implementation FMContentView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

-(void)mouseEntered:(NSEvent *)theEvent{
    NSLog(@"mouseEntered");
    [self.delegete mouseEntered:theEvent];
    
}
-(void)mouseExited:(NSEvent *)theEvent{
    NSLog(@"mouseExited");
    [self.delegete mouseExited:theEvent];
}
-(void)mouseUp:(NSEvent *)theEvent{
    [self.delegete mouseUp:theEvent];
    if (!isDrag) {
        [self.delegete contentViewClick:theEvent];
    }
    isDrag = NO;
}

-(void)mouseDown:(NSEvent *)theEvent {
    NSRect  windowFrame = [[self.delegete window] frame];
    
    initialLocation = [NSEvent mouseLocation];
    
    initialLocation.x -= windowFrame.origin.x;
    initialLocation.y -= windowFrame.origin.y;
}

- (void)mouseDragged:(NSEvent *)theEvent {
    NSPoint currentLocation;
    NSPoint newOrigin;
    
    NSRect  screenFrame = [[NSScreen mainScreen] frame];
    NSRect  windowFrame = [self frame];
    
    isDrag = YES;
    
    currentLocation = [NSEvent mouseLocation];
    newOrigin.x = currentLocation.x - initialLocation.x;
    newOrigin.y = currentLocation.y - initialLocation.y;
    
    // Don't let window get dragged up under the menu bar
    if( (newOrigin.y+windowFrame.size.height) > (screenFrame.origin.y+screenFrame.size.height) ){
        newOrigin.y=screenFrame.origin.y + (screenFrame.size.height-windowFrame.size.height);
    }
    
    //go ahead and move the window to the new location
    [[self.delegete window] setFrameOrigin:newOrigin];
}



@end
