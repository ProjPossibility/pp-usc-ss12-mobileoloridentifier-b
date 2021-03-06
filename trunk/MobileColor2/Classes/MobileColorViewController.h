//
//  MobileColorViewController.h
//  MobileColor
//
//  Created by Mathews Kodiatte on 2/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


#import <UIKit/UIKit.h>

@class OverlayView;
@class ColorModel;

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
	OverlayView *overlayView;
	ColorModel *colorModel;
	UIView *parentView;
	UIToolbar *toolBar;
	NSArray *items;
	IBOutlet UILabel *loadingCameraLabel;
	NSObject *v;
	NSString *currentName_;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) IBOutlet UIButton *selectFromCameraRollButton;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain) IBOutlet UILabel *tapsLabel;
@property (nonatomic, retain) IBOutlet UILabel *touchesLabel;
@property (nonatomic, copy) NSString *currentName;

- (void)updateLabelsFromTouches:(NSSet *)touches;
- (IBAction)getCameraPicture; //:(id)sender;
- (IBAction)selectExistingPicture;
@end


