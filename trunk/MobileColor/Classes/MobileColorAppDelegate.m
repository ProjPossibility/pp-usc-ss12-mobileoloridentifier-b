//
//  MobileColorAppDelegate.m
//  MobileColor
//
//  Created by Mathews Kodiatte on 2/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MobileColorAppDelegate.h"
#import "MobileColorViewController.h"

@implementation MobileColorAppDelegate

@synthesize window;
@synthesize viewController;




- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
