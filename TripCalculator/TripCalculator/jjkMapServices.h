//
//  jjkMapServices.h
//  TripCalculator
//
//  Created by Joshua Kuiros on 11/20/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface jjkMapServices : NSObject

- (void)setDirectionsQuery:(NSDictionary *)object withSelector:(SEL)selector withDelegate:(id)delegate;
- (void)retrieveDirections:(SEL)sel withDelegate:(id)delegate;
- (void)fetchedData:(NSData *)data withSelector:(SEL)selector withDelegate:(id)delegate;

@end
