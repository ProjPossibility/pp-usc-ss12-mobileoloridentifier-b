//
//  MobileColorAppDelegate.h
//  MobileColor
//
//  Created by Mathews Kodiatte on 2/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MobileColorViewController;

@interface MobileColorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MobileColorViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MobileColorViewController *viewController;

@end

