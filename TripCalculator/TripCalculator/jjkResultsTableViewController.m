//
// Mike Green Josh Kuiros
// Final Project
// 12/16/13
//
#import "jjkResultsTableViewController.h"

#define METERS_IN_MILES .000621371


@interface jjkResultsTableViewController ()

@property(strong, nonatomic)UIFont *cellFont;

@end

@implementation jjkResultsTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cellFont = [[UIFont alloc] init];
    self.cellFont = [UIFont fontWithName:@"System" size:15];
    double convert = self.shortestRoute.distance;
    convert = convert * METERS_IN_MILES;
    
    self.title = [NSString stringWithFormat:@"Total Miles: %.01f", convert];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shortestRoute.steps.count;
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
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
    cell.distanceLabel.textColor = [UIColor orangeColor];
    
    MKRouteStep *temporary = [self.shortestRoute.steps objectAtIndex:indexPath.row];
    
    float mileConversion = temporary.distance * METERS_IN_MILES;
    cell.directionLabel.text = temporary.instructions;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.02f miles",mileConversion];
    
    return cell;
}


@end
