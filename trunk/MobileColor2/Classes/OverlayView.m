//
//  OverlayView.m
//  MobileColor
//
//  Created by Elliot Lee on 2/28/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "OverlayView.h"


@implementation OverlayView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(10, 260, 300, 50)];
		blackView.backgroundColor = [UIColor blackColor];
		blackView.alpha = 0.5f;
		[self addSubview:blackView];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(10, 260, 300, 50)];
		label.backgroundColor = [UIColor clearColor]; //[UIColor blackColor];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		
		
    }
    return self;
}

- (void)showText:(NSString *)text {
	label.text = text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
