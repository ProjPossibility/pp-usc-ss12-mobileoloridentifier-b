//
//  MobileColorViewController.m
//  MobileColor
//
//  Created by Mathews Kodiatte on 2/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MobileColorViewController.h"
#import "OverlayView.h"
#import "ColorModel.h"

@implementation MobileColorViewController

@synthesize imageView;
@synthesize takePictureButton;
@synthesize selectFromCameraRollButton;
@synthesize messageLabel;
@synthesize tapsLabel;
@synthesize touchesLabel;



typedef struct {
	uint8_t *rawImage;
	uint8_t **pixels;
	int width;
	int height;
} Image;

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.imageView = nil;
    self.takePictureButton = nil;
    self.selectFromCameraRollButton = nil;
    [super viewDidUnload];
}
- (void)dealloc {
    [imageView release];
    [takePictureButton release];
    [selectFromCameraRollButton release];
    [super dealloc];
}
#pragma mark -

-(void) finishedAugmentedReality {
	[self dismissModalViewControllerAnimated:YES];
	[processingTimer invalidate];
	//overlayView=nil;
}

- (IBAction)getCameraPicture { //:(id)sender {
	// set up our camera overlay view
	
	if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
		[self selectExistingPicture];
		return;
//        takePictureButton.hidden = YES;
//        selectFromCameraRollButton.hidden = YES;
    }
	
	//NSLog(@"getCameraPicture");
	
	/* You'll need to link to VoiceServices.framework in PrivateFrameworks */
	
	NSObject *v = [[NSClassFromString(@"VSSpeechSynthesizer") alloc] init]; // I'm lazy
	NSLog(@"%@", v);
	[v startSpeakingString:@"All your base are belong to us"];
	
//	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//	button.frame = CGRectMake(20,400,280,50);
//	[button setTitle:@"Tap here" forState:UIControlStateNormal];
//	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//	[button addTarget:self action:@selector(selectExistingPicture) forControlEvents:UIControlEventTouchUpInside];
//	[self.view addSubview:button];
	
	[toolBar setItems:items animated:NO];
	
	// configure the image picker with our overlay view
	UIImagePickerController *picker=[[UIImagePickerController alloc] init];
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
//	picker.delegate = self;
//    picker.allowsImageEditing = YES;
//    picker.sourceType = (sender == takePictureButton) ? UIImagePickerControllerSourceTypeCamera :UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	
	UIImagePickerControllerSourceTypePhotoLibrary;
	// hide the camera controls
	//picker.showsCameraControls=NO;
	picker.delegate = nil;
	//picker.allowsImageEditing = NO;
	picker.allowsEditing = NO;
	
	//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
	//iphone screen dimensions
//#define SCREEN_WIDTH  320
//#define SCREEN_HEIGTH 480
	
	//hide all controls
	picker.showsCameraControls = NO;
	picker.navigationBarHidden = YES;
	picker.toolbarHidden = YES;
	//make the video preview full size
	picker.wantsFullScreenLayout = YES;
//	picker.cameraViewTransform =
//	CGAffineTransformScale(picker.cameraViewTransform,
//						   CAMERA_TRANSFORM_X,
//						   CAMERA_TRANSFORM_Y);
	picker.cameraViewTransform=
	CGAffineTransformScale(picker.cameraViewTransform, 1.0, 1.13); 
	
	
	// and put our overlay view in
	picker.cameraOverlayView=parentView;
	[self presentModalViewController:picker animated:YES];		
	[picker release];
	// start our processing timer
	processingTimer=[NSTimer scheduledTimerWithTimeInterval:1/5.0f target:self selector:@selector(processImage) userInfo:nil repeats:YES];
}

- (IBAction)selectExistingPicture {
	
	
	
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
		if ([self modalViewController]) {
			//[self finishedAugmentedReality];
			[self dismissModalViewControllerAnimated:NO];
			[processingTimer invalidate];
			//overlayView=nil;
		}
		loadingCameraLabel.hidden = YES;
		
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //picker.allowsImageEditing = YES;
		picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Error accessing photo library" 
                              message:@"Device does not support a photo library" 
                              delegate:nil 
                              cancelButtonTitle:@"Drat!" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


#pragma mark  -
- (void)imagePickerController:(UIImagePickerController *)picker 
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    //imageView
	imageView.image = image;
    [picker dismissModalViewControllerAnimated:YES];
	
	[self.view addSubview:parentView];
	
	NSMutableArray *itemsAndCameraButton = [[items mutableCopy] autorelease];
	[itemsAndCameraButton addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(getCameraPicture)] autorelease]];
	[toolBar setItems:itemsAndCameraButton animated:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:NO];
	
	[self getCameraPicture];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	colorModel = [[ColorModel alloc] init];
	
	// tool bar - handy if you want to be able to exit from the image picker...
	//UIToolbar *
	toolBar=[[[UIToolbar alloc] initWithFrame:CGRectMake(0, 480-44, 320, 44)] autorelease];
	//NSArray *
	items=[[NSArray arrayWithObjects:
					[[[UIBarButtonItem alloc] initWithTitle:@"Albums" style:UIBarButtonItemStyleBordered target:self action:@selector(selectExistingPicture)] autorelease],
					[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil] autorelease],
					//[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone  target:self action:@selector(finishedAugmentedReality)] autorelease],
					nil] retain];
	//[toolBar setItems:items];
	
	// create the overlay view
	overlayView=[[OverlayView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-44)]; // autorelease];
	// important - it needs to be transparent so the camera preview shows through!
	overlayView.opaque=NO;
	overlayView.backgroundColor=[UIColor clearColor];
	
	
	
	// parent view for our overlay
	parentView=[[UIView alloc] initWithFrame:CGRectMake(0,0,320, 480)]; // autorelease];
	[parentView addSubview:overlayView];
	[parentView addSubview:toolBar];
	
	
	
	
	// start camera
	[self performSelector:@selector(getCameraPicture) withObject:nil afterDelay:0.0f];
	//[self getCameraPicture];
	
	
	
}

- (void)updateLabelsFromTouches:(NSSet *)touches {
    NSUInteger numTaps = [[touches anyObject] tapCount];
    NSString *tapsMessage = [[NSString alloc]
                             initWithFormat:@"%d taps detected", numTaps];
    tapsLabel.text = tapsMessage;
    [tapsMessage release];
    
    NSUInteger numTouches = [touches count];
    NSString *touchMsg = [[NSString alloc] initWithFormat:
                          @"%d touches detected", numTouches];
    touchesLabel.text = touchMsg;
    [touchMsg release];
}


#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    messageLabel.text = @"Touches Began";
    [self updateLabelsFromTouches:touches];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    messageLabel.text = @"Touches Cancelled";
    [self updateLabelsFromTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self updateLabelsFromTouches:touches];
	//Get all the touches.
	NSSet *allTouches = [event allTouches];
	
	//Number of touches on the screen
	switch ([allTouches count])
	{
		case 1:
		{
			//Get the first touch.
			UITouch *touch = [touches anyObject];
			
			temp = [touch locationInView:self.view];
//			NSString *locnMessage = [[NSString alloc]
//									 initWithFormat:@"%f is x %f is y", temp.x, temp.y];
//			messageLabel.text = locnMessage;
//			
			CGRect screenRect = [[UIScreen mainScreen] bounds];
			UIGraphicsBeginImageContext(screenRect.size);
			[(CALayer *)self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
			UIImage *sShot = UIGraphicsGetImageFromCurrentImageContext();
			CGImageRef sShotCG = sShot.CGImage;
			UIGraphicsEndImageContext();
			
//			UIGraphicsBeginImageContext(CGSizeMake(200, 100));
//			//UIGraphicsPushContext(sShot);	
//			UIImage *updatedImg = [self addText:sShot text:locnMessage temp:temp];
//			
//			UIImageView *iView = [[UIImageView alloc] initWithImage:updatedImg]; 
//			[self.view addSubview:iView];
//			
//			[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//			//UIImageWriteToSavedPhotosAlbum(updatedImg, nil, nil, nil);
			
			if (!overlayView.superview) {
				[self.view addSubview:overlayView];
			}
			
			[self getPixelColorAtLocation:temp ofCGImage:sShotCG];
			
//			UIGraphicsEndImageContext();

			
		} 
		//NSLog(@"%f is x %f is y", temp.x, temp.y);	
		break;
	}
	
	
}

//Add text to UIImage
-(UIImage *)addText:(UIImage *)img text:(NSString *)text1 temp:(CGPoint)temp{
    int w = img.size.width;
    int h = img.size.height; 
    //lon = h - lon;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1);
	
    char* text	= (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];// "05/05/09";
    CGContextSelectFont(context, "Arial", 9, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
	
	
    //rotate text
    //CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/4 ));
	
    CGContextShowTextAtPoint(context, temp.x, h-temp.y, text, strlen(text));
	
	
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	
    return [UIImage imageWithCGImage:imageMasked];
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    messageLabel.text = @"Drag Detected";
    [self updateLabelsFromTouches:touches];
    
}

CGImageRef UIGetScreenImage();

-(void) processImage {
	// grab the screen
	CGImageRef screenCGImage=UIGetScreenImage();
	CGPoint pointCamera;
	pointCamera.x = 160;
	pointCamera.y = 240;
	NSString *locnMessage = [[NSString alloc]
							 initWithFormat:@"%f is x %f is y", pointCamera.x, pointCamera.y];
	// turn it into something we can use
	//UIColor *color = 
	[self getPixelColorAtLocation:pointCamera ofCGImage:screenCGImage];
//	UIImage *updatedImg = [self addText:[UIImage imageWithCGImage:screenCGImage] text:locnMessage temp:temp];
//	
//	UIImageView *iView = [[UIImageView alloc] initWithImage:updatedImg]; 
//	[self.view addSubview:iView];
	
	
	
	CGImageRelease(screenCGImage);
	//destroyImage(screenCGImage);
}


- (UIColor*) getPixelColorAtLocation:(CGPoint)point ofCGImage:(CGImageRef)inImage {
	UIColor* color = nil;
	//CGImageRef inImage = self.image.CGImage;
	// Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
	CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
	if (cgctx == NULL) { return nil; /* error */ }
	
    size_t w = CGImageGetWidth(inImage);
	size_t h = CGImageGetHeight(inImage);
	CGRect rect = {{0,0},{w,h}}; 
	
	// Draw the image to the bitmap context. Once we draw, the memory
	// allocated for the context for rendering will then contain the
	// raw image data in the specified color space.
	CGContextDrawImage(cgctx, rect, inImage); 
	
	// Now we can get a pointer to the image data associated with the bitmap
	// context.
	unsigned char* data = CGBitmapContextGetData (cgctx);
	if (data != NULL) {
		//offset locates the pixel in the data from x,y.
		//4 for 4 bytes of data per pixel, w is width of one row of data.
		int offset = 4*((w*round(point.y))+round(point.x));
		int alpha =  data[offset];
		int red = data[offset+1];
		int green = data[offset+2];
		int blue = data[offset+3];
//		NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
		color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
		[overlayView showText:[colorModel nameForColorGivenRed:red Green:green Blue:blue]]; //[NSString stringWithFormat:@"RGB %i %i %i",red,green,blue]];
//		NSLog(@"%@", [NSString stringWithFormat:@"%@", color]);
	}
	
	// When finished, release the context
	CGContextRelease(cgctx);
	// Free image data memory for the context
	if (data) { free(data); }
	
	return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
	
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	
	// Get image width, height. We'll use the entire image.
	size_t pixelsWide = CGImageGetWidth(inImage);
	size_t pixelsHigh = CGImageGetHeight(inImage);
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
	// Use the generic RGB color space.
	colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n");
		return NULL;
	}
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL)
	{
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
	
	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits
	// per component. Regardless of what the source image format is
	// (CMYK, Grayscale, and so on) it will be converted over to the format
	// specified here by CGBitmapContextCreate.
	context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedFirst);
	if (context == NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
	}
	
	// Make sure and release colorspace before returning
	CGColorSpaceRelease( colorSpace );
	
	return context;
}




@end
