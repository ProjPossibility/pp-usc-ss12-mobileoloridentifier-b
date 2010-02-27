//
//  ColorDictionary.m
//  mobileColor
//
//  Created by Mathews Kodiatte on 2/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ColorDictionary.h"


@implementation ColorDictionary

-(id) init{
	if(self = [super init] )
	{
		dictionary=[[NSDictionary dictionaryWithObjectsAndKeys:
					@"Red",@"1111",
					@"Green",@"2222",nil]retain];
	}
	return self;	
}

-(NSDictionary*)dictionary{
	return dictionary;
}

@end
