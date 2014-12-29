//
//  MyCoverView.m
//  doubanfm
//
//  Created by Mike on 14/12/6.
//  Copyright (c) 2014年 hyz. All rights reserved.
//

#import "FMCoverView.h"

@implementation FMCoverView

-(id)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    
    [self setWantsLayer:YES];
    self.layer.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor;
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
