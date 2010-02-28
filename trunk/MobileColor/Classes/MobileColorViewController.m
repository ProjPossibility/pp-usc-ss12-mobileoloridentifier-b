//
//  MobileColorViewController.m
//  MobileColor
//
//  Created by Mathews Kodiatte on 2/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MobileColorViewController.h"
#import "ColorModel.h"

@interface NSString (HexUtilities)

- (int)hexValueAsInt;

@end

@implementation NSString (HexUtilities)

- (int)decimalFromHexChar:(unichar)c {
	if (c >= 'A') {
		return (c - 'A') + 10;
	}
	return c - '0';
}

- (int)hexValueAsInt {
	int msd = [self decimalFromHexChar:[self characterAtIndex:0]];
	int lsd = [self decimalFromHexChar:[self characterAtIndex:1]];
	return 16*msd+lsd;
}

@end


@implementation MobileColorViewController

@synthesize colorNameLabel;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	colorModel=[[ColorModel alloc] init];						//creating the object
	
	NSString *key = @"E8D15F";
	NSLog(@"%d", [[key substringToIndex:2] hexValueAsInt]);
	NSLog(@"%d", [[key substringWithRange:NSMakeRange(2,2)] hexValueAsInt]);
	NSLog(@"%d", [[key substringFromIndex:4] hexValueAsInt]);

	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	// colorNameLabel.text = [[colorModel dictionary] objectForKey:textField.text];		// setting the label to the object returned
	//NSString* tempString=[colorModel nameForColorGivenRed:255 Green:0 Blue:0];
	colorNameLabel.text = [colorModel nameForColorGivenRed:0 Green:71 Blue:22];
	
	//colorNameLabel.text=(char)'F'-i;
	
	//-(NSString*)nameForColorGivenRed:(int)r Green:(int)g Blue:(int)b
	//colorNameLabel.text = returnString;
	return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}

@end
