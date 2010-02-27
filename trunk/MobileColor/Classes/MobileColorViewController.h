//
//  MobileColorViewController.h
//  MobileColor
//
//  Created by Mathews Kodiatte on 2/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorDictionary;

@interface MobileColorViewController : UIViewController {
	UILabel *colorNameLabel;
	ColorDictionary *colorDictionary;
}

@property (nonatomic, retain) IBOutlet UILabel *colorNameLabel; 

@end

