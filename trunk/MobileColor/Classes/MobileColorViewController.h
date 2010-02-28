//
//  MobileColorViewController.h
//  MobileColor
//
//  Created by Mathews Kodiatte on 2/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorModel;

@interface MobileColorViewController : UIViewController {
	UILabel *colorNameLabel;
	ColorModel *colorModel;
}

@property (nonatomic, retain) IBOutlet UILabel *colorNameLabel; 

@end

