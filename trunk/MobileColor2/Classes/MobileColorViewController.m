//
//  MobileColorViewController.m
//  MobileColor
//
//  Created by Mathews Kodiatte on 2/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MobileColorViewController.h"

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
- (IBAction)getCameraPicture:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsImageEditing = YES;
    picker.sourceType = (sender == takePictureButton) ? UIImagePickerControllerSourceTypeCamera :UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentModalViewController:picker animated:YES];
	processingTimer=[NSTimer scheduledTimerWithTimeInterval:1/5.0f target:self selector:@selector(processImage) userInfo:nil repeats:YES];
    [picker release];
    
}
- (IBAction)selectExistingPicture {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsImageEditing = YES;
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
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        takePictureButton.hidden = YES;
        selectFromCameraRollButton.hidden = YES;
    }
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(20,400,280,50);
	[button setTitle:@"Tap here" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(selectExistingPicture) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
	
	
	
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
			NSString *locnMessage = [[NSString alloc]
									 initWithFormat:@"%f is x %f is y", temp.x, temp.y];
			messageLabel.text = locnMessage;
			
			CGRect screenRect = [[UIScreen mainScreen] bounds];
			UIGraphicsBeginImageContext(screenRect.size);
			[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
			UIImage *sShot = UIGraphicsGetImageFromCurrentImageContext();
			CGImageRef sShotCG = sShot.CGImage;
			
			UIGraphicsBeginImageContext(CGSizeMake(200, 100));
			//UIGraphicsPushContext(sShot);	
			UIImage *updatedImg = [self addText:sShot text:locnMessage temp:temp];
			
			UIImageView *iView = [[UIImageView alloc] initWithImage:updatedImg]; 
			[self.view addSubview:iView];
			
			[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
			//UIImageWriteToSavedPhotosAlbum(updatedImg, nil, nil, nil);
			
			[self getPixelColorAtLocation:temp ofCGImage:sShotCG];
			
			UIGraphicsEndImageContext();

			
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
	pointCamera.x = 240;
	pointCamera.y = 160;
	NSString *locnMessage = [[NSString alloc]
							 initWithFormat:@"%f is x %f is y", pointCamera.x, pointCamera.y];
	// turn it into something we can use
	[self getPixelColorAtLocation:pointCamera ofCGImage:screenCGImage];
	UIImage *updatedImg = [self addText:[UIImage imageWithCGImage:screenCGImage] text:locnMessage temp:temp];
	
	UIImageView *iView = [[UIImageView alloc] initWithImage:updatedImg]; 
	[self.view addSubview:iView];
	
	
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
		NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
		color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
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
