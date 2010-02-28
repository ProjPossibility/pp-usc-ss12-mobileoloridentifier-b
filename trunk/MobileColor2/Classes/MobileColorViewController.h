//
//  MobileColorViewController.h
//  MobileColor
//
//  Created by Mathews Kodiatte on 2/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface MobileColorViewController : UIViewController 
<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImageView *imageView;
    UIButton *takePictureButton;
    UIButton *selectFromCameraRollButton;
	UILabel    *messageLabel;
    UILabel    *tapsLabel;
    UILabel    *touchesLabel; 
	NSTimer *processingTimer;
	CGPoint temp;
	
	
}
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) IBOutlet UIButton *selectFromCameraRollButton;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain) IBOutlet UILabel *tapsLabel;
@property (nonatomic, retain) IBOutlet UILabel *touchesLabel;

- (void)updateLabelsFromTouches:(NSSet *)touches;
- (IBAction)getCameraPicture:(id)sender;
- (IBAction)selectExistingPicture;
@end


