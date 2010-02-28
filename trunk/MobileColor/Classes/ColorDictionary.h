//
//  ColorDictionary.h
//  mobileColor
//
//  Created by Mathews Kodiatte on 2/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ColorDictionary : NSObject {
		NSDictionary *dictionary;				//creating an instance of ColorDictionary
	
}

-(NSDictionary *)dictionary;					//declaring a method

-(NSString *)nameForColorWithRed:(int)r green:(int)g blue:(int)b;	//declaring the method to calculate the closest color value
//nameForColorWithRed:green:blue:
@end
