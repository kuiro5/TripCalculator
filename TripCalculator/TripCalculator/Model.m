//
//  Model.m
//  TripCalculator
//
//  Created by Joshua Kuiros on 12/9/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "Model.h"
@interface Model ()
@property (strong,nonatomic) NSMutableArray *costInformation;

@end
@implementation Model

+(id)sharedInstance
{
    static id singleton = nil;
    if (!singleton)
    {
        singleton = [[self alloc] init];
    }
    return singleton;
}

-(id) init
{
    self = [super init];
    if(self)
    {
        // initialization
        self.costInformation = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addNewCost:(NSDictionary*)newCost
{
    NSLog(@"adding new cost");
    [self.costInformation addObject:newCost];


}

@end
