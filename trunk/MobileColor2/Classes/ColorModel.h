//
//  ColorDictionary.h
//  mobileColor
//
//  Created by Mathews Kodiatte on 2/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NUMCOLORS 1567


@interface ColorModel : NSObject {
		NSDictionary *dictionary;				//creating an instance of a NSDictionary
		int red[NUMCOLORS],green[NUMCOLORS],blue[NUMCOLORS];
		//NSString* colorNameArray=new NSString[NUMCOLORS];
	    NSMutableArray *colorNameArray;
}

-(NSDictionary *)dictionary;					//declaring a method

-(NSString *)nameForColorGivenRed:(int)r green:(int)g blue:(int)b;	//declaring the method to calculate the closest color value

-(int)hexToInteger:(char)c;

@end
