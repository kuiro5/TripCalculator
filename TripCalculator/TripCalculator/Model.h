//
//  Model.h
//  TripCalculator
//
//  Created by Joshua Kuiros on 12/9/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
+(id)sharedInstance;
-(void)addNewCost:(NSDictionary*)newCost;
-(NSMutableArray*)currentCostInformation;
@end
