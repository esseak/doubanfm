//
//  FMButtonCell.m
//  doubanfm
//
//  Created by Mike on 14/12/7.
//  Copyright (c) 2014年 hyz. All rights reserved.
//

#import "FMButtonCell.h"

@implementation FMButtonCell

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    NSLog(@"ss %@",[NSBundle mainBundle]);
    
    onStateImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ffw" ofType:@"png"]];
    offStateImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ffw" ofType:@"png"]];
    downStateImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ffw_on" ofType:@"png"]];
    NSLog(@"initWithCoder");
    return self;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if ([self state])
    {
        [onStateImage drawInRect:cellFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }
    else
    {
        [offStateImage drawInRect:cellFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }
}
- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if (flag){
        [downStateImage drawInRect:cellFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        
    }
}

@end
