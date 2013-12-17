//
// Mike Green Josh Kuiros
// Final Project
// 12/16/13
//

#import "jjkComprehensiveViewController.h"


@interface jjkComprehensiveViewController ()

@property(strong, nonatomic) NSMutableArray *totalCostsInformation;

@end

@implementation jjkComprehensiveViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _model = [Model sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.totalCostsInformation = [[NSMutableArray alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self setCostTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.costType isEqualToString:@"Gas"])
    {
        self.totalCostsInformation = self.model.gasCostArray;
        return [self.model.gasCostArray count];
    }
    if([self.costType isEqualToString:@"Food"])
    {
        self.totalCostsInformation = self.model.foodCostArray;
        return [self.model.foodCostArray count];
    }
    if([self.costType isEqualToString:@"Misc"])
    {
        self.totalCostsInformation = self.model.miscCostArray;
        return [self.model.miscCostArray count];
    }
    if([self.costType isEqualToString:@"Tolls"])
    {
        self.totalCostsInformation = self.model.tollCostArray;
        return [self.model.tollCostArray count];
    }
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
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
    cell.directionLabel.text = self.costType;
    
    NSString *temporaryMoney = [[self.totalCostsInformation objectAtIndex:indexPath.row] objectForKey:@"money cost"];
    float cost = [temporaryMoney floatValue];
    cell.distanceLabel.text = [NSString stringWithFormat:@"$%.02f", cost];
    cell.smallLabel.text =  [[self.totalCostsInformation objectAtIndex:indexPath.row] objectForKey:@"description"];
    
    return cell;
    
}
-(void)setCostTitle
{
    float total = 0;
    
    for(NSDictionary *index in self.totalCostsInformation)
    {
        NSString *temporaryMoney = [index objectForKey:@"money cost"];
        float temporary = [temporaryMoney floatValue];
        total += temporary;
    }
    
    self.title = [NSString stringWithFormat:@"$%.02f", total];
}

@end
