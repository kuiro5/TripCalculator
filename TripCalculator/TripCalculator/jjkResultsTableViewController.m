//
//  jjkResultsTableViewController.m
//  TripCalculator
//
//  Created by Joshua Kuiros on 12/5/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkResultsTableViewController.h"
#import "jjkResultsCell.h"

@interface jjkResultsTableViewController ()

//@property (strong, nonatomic) MKRoute *selectedDirections;

@end

@implementation jjkResultsTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    double convert = self.shortestRoute.distance;
    convert = convert * .000621371;
    
    self.title = [NSString stringWithFormat:@"Total Miles: %.01f", convert];
    //self.selectedDirections = self.shortestRoute;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"calling numbers");
    NSLog(@"%d", self.shortestRoute.steps.count);
    return self.shortestRoute.steps.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //NSLog(@"calling tableView");
    static NSString *CellIdentifier = @"resultCell";
    jjkResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        
        cell = [[jjkResultsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }
    
    UIColor* const COLOR_LIGHT_BLUE = [[UIColor alloc] initWithRed:21.0f/255 green:180.0f/255  blue:1 alpha:1];
    
    
    tableView.backgroundView = nil;
    
    tableView.backgroundView = [[UIView alloc] init];
    
    tableView.separatorColor = [UIColor grayColor];
    
    tableView.backgroundColor = [UIColor whiteColor];
    
    cell.directionLabel.textColor = COLOR_LIGHT_BLUE;
    
    cell.noticeLabel.textColor = [UIColor orangeColor];
    
    cell.distanceLabel.textColor = [UIColor orangeColor];
    
    
    
    MKRouteStep *temporary = [self.shortestRoute.steps objectAtIndex:indexPath.row];
    
    float mileConversion = temporary.distance * 0.000621371;
    cell.directionLabel.text = temporary.instructions;
    [cell.directionLabel sizeToFit];
    cell.noticeLabel.text = temporary.notice;
    [cell.noticeLabel sizeToFit];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.02f miles",mileConversion];
    
    
    
    
    return cell;
    
}


@end
