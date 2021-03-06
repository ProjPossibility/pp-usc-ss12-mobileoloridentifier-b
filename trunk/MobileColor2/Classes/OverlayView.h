//
//  OverlayView.h
//  MobileColor
//
//  Created by Elliot Lee on 2/28/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OverlayView : UIView {
	UILabel *label;
	UIView *colorView;
}

- (void)showText:(NSString *)text;
- (void)setColor:(UIColor *)color;

@end
