//
//  MobileColorViewController.m
//  MobileColor
//
//  Created by Mathews Kodiatte on 2/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MobileColorViewController.h"
#import "ColorModel.h"
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
