//
//  Model.m
//  TripCalculator
//
//  Created by Joshua Kuiros on 12/9/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "Model.h"
@interface Model ()
@property (strong,retain) NSMutableArray *costInformation;

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
        NSDictionary *newCost = [[NSDictionary alloc] initWithObjectsAndKeys: @"gas", @"cost type", @"20", @"money cost", @"", @"description", @"", @"latitude", @"", @"longitude",  nil];

        self.costInformation = [[NSMutableArray alloc] init ];//]WithObjects:newCost, nil];
    }
    return self;
}

-(NSMutableArray*)currentCostInformation
{
  
    return _costInformation;
}

-(void)addNewCost:(NSDictionary*)newCost
{
   
    NSLog(@"adding new cost");
    [self.costInformation addObject:newCost];


}

@end
