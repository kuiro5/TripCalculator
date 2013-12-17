//
// Mike Green Josh Kuiros
// Final Project
// 12/16/13
//

#import "jjkGraphViewController.h"

#define LABEL_OFFSET 100
#define PADDING 175
#define SCREEN_PERCENTAGE .7
#define SCREEN_THIRD 3
#define CORNER_RADIUS 5.0
#define PERCENTAGE 100
#define NUMBER_OF_RECORDS 4
#define DIVISOR 1000

@interface jjkGraphViewController ()

@property (strong, nonatomic) CPTGraphHostingView *hostView;
@property (strong, nonatomic) CPTTheme *selectedTheme;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) NSMutableArray *totalCostSum;
@property (strong, nonatomic) CPTGraph *mainGraph;
@property (strong, nonatomic) CPTPieChart *pieChart;
@property (weak, nonatomic) IBOutlet UILabel *moneySpentLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLeftLabel;
@property (strong, nonatomic) NSString *timeStopped;

- (IBAction)endTrip:(id)sender;

@end

@implementation jjkGraphViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _model = [Model sharedInstance];
    }
    
    return self;
}

-(id)init
{
    if(self)
    {
        self.timeStopped = @"";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(![self.model.tripName isEqualToString:@""])
    {
        self.title = self.model.tripName;
    }
    
    [self updateCostLabels];
    
    self.totalCostSum = [[NSMutableArray alloc] init];
    self.totalCostSum = [self.model totalsArray];
    
    if(!self.model.timestopped)                             // trip has been ended
    {
        if(startTimer)
        {
            [self.model startTimer];
            startTimer = NO;
        }
    }
    else
    {
        self.timerLabel.text = self.model.timeEnded;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    self.totalCostSum = [self.model totalsArray];
    [self initPlot];
    [self updateCostLabels];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if(!self.model.timestopped)                                // trip has ended
    {
        self.model.tripTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/60) target:self selector:@selector(updateTimeDisplay) userInfo:nil repeats:YES];
    }
    else
    {
        self.timerLabel.text = self.model.timeEnded;
    }
    [self updateCostLabels];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

-(void)updateCostLabels             // update money spent and money left
{
    float moneySpent =  0;
    NSMutableArray *costs = [self.model currentTotalCostInformation];
    
    for(NSDictionary *index in costs)
    {
        NSNumber *currentCostAmount = [index objectForKey:@"total"];
        float temporaryFloat = [currentCostAmount floatValue];
        moneySpent += temporaryFloat;
    }
    
    self.moneySpentLabel.text = [NSString stringWithFormat:@"Spent: $%.02f", moneySpent];
    float moneyLeft =[self.model budgetValue] - moneySpent;
    self.moneyLeftLabel.text = [NSString stringWithFormat:@"Remaining: $%.02f", moneyLeft];
}



-(void)initPlot
{
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}



-(void)configureHost                // create host view for graph
{
    CGRect parentRect = self.view.bounds;
    parentRect = CGRectMake(parentRect.origin.x,
                            parentRect.origin.y + LABEL_OFFSET,
                            parentRect.size.width,
                            parentRect.size.height - LABEL_OFFSET - PADDING);
    
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = NO;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph
{

    // Initalize graph and attributes
    self.mainGraph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.mainGraph.borderColor = [[UIColor clearColor] CGColor];
    self.mainGraph.backgroundColor = [[UIColor lightGrayColor] CGColor];
    self.mainGraph.fill = nil;
    self.hostView.hostedGraph = self.mainGraph;
    self.mainGraph.paddingLeft = 0.0f;
    self.mainGraph.paddingTop = 0.0f;
    self.mainGraph.paddingRight = 0.0f;
    self.mainGraph.paddingBottom = 0.0f;
    self.mainGraph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    self.mainGraph.axisSet = nil;
    
    // Set text attributes
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor orangeColor];
    textStyle.fontName = @"Noteworthy";
    textStyle.fontSize = 28.0f;
    
    // Set title
    NSString *title = @"Cost Guide";
    self.mainGraph.title = title;
    self.mainGraph.titleTextStyle = textStyle;
    self.mainGraph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    self.mainGraph.titleDisplacement = CGPointMake(0.0f, -self.view.bounds.size.height/DIVISOR);
   
    // Set theme
    self.selectedTheme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [self.mainGraph applyTheme:self.selectedTheme];
}

-(void)configureChart
{
    CPTGraph *graph = self.hostView.hostedGraph;
 
    // Create chart to add to graph
    self.pieChart = [[CPTPieChart alloc] init];
    self.pieChart.dataSource = self;
    self.pieChart.delegate = self;
    self.pieChart.backgroundColor = [[UIColor clearColor] CGColor];
    self.pieChart.borderColor = [[UIColor clearColor] CGColor];
    self.pieChart.pieRadius = (self.hostView.bounds.size.width * SCREEN_PERCENTAGE) / SCREEN_THIRD;
    self.pieChart.identifier = graph.title;
    self.pieChart.startAngle = M_PI_4;
    self.pieChart.sliceDirection = CPTPieDirectionClockwise;

    // Set chart theme/colors
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    self.pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
   
    // Add the chart to existing graph
    [graph addPlot:self.pieChart];
}

-(void)configureLegend
{
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];

    // init legend
    theLegend.numberOfColumns = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = CORNER_RADIUS;
   
    // add legend to graph
    graph.legend = theLegend;
    graph.legendAnchor = CPTRectAnchorBottomRight;
    CGFloat legendPadding = -(self.view.bounds.size.width / PERCENTAGE);
    graph.legendDisplacement = CGPointMake(legendPadding, -legendPadding);
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        NSString *typeOfCostSelected;
        if([sender tag] == 0)
        {
            typeOfCostSelected = @"Gas";
        }
        if([sender tag] == 1)
        {
            typeOfCostSelected = @"Misc";
        }
        if([sender tag] == 2)
        {
            typeOfCostSelected = @"Food";
        }
        if([sender tag] == 3)
        {
            typeOfCostSelected = @"Tolls";
        }

        if([segue.identifier isEqualToString:@"ComprehensiveSegue"])
        {
            jjkComprehensiveViewController *comprehensiveView = segue.destinationViewController;
            comprehensiveView.costType = typeOfCostSelected;
        }
}



-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return NUMBER_OF_RECORDS;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    self.totalCostSum = [self.model totalsArray];                   // array with totals for each cost type
    
    if (CPTPieChartFieldSliceWidth == fieldEnum)                    // return totals for each cost type
    {
        NSMutableDictionary *costData = [self.totalCostSum objectAtIndex:index];
        NSNumber  *costNumber = [costData objectForKey:@"total"];
        return costNumber;
    }
    
    return [NSDecimalNumber zero];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    // Data label text/color
    static CPTMutableTextStyle *labelText = nil;
    if (!labelText)
    {
        labelText= [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor grayColor];
    }
    
    // Cost totals
    NSDecimalNumber *portfolioSum = [NSDecimalNumber zero];
    for (NSDictionary *costData in self.totalCostSum)
    {
        NSNumber  *costNumber = [costData objectForKey:@"total"];
        NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:[costNumber decimalValue]];
        portfolioSum = [portfolioSum decimalNumberByAdding:result];
    }
    
    // Calculate percentages
    NSDictionary *currentRecord = [self.totalCostSum objectAtIndex:index];
    NSNumber  *recordCostNumber = [currentRecord objectForKey:@"total"];
    NSDecimalNumber *recordDecimal = [NSDecimalNumber decimalNumberWithDecimal:[recordCostNumber decimalValue]];
    
    // Display label if it is not 0
    if([portfolioSum integerValue] != 0 && [recordCostNumber integerValue] != 0)
    {
        NSDecimalNumber *percent = [recordDecimal decimalNumberByDividingBy:portfolioSum];
        NSString *labelValue = [NSString stringWithFormat:@"%0.1f %%", ([percent floatValue] * 100.0f)];
        return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
    }
    else
    {
        return [[CPTTextLayer alloc] initWithText:nil style:nil];
    }
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    if (index < [self.totalCostSum count])      // add strings to legend
    {
        NSDictionary *currentDictionary = [self.totalCostSum objectAtIndex:index];
        NSString *currentType = [currentDictionary objectForKey:@"type"];
        return currentType;
    }
    return @"N/A";
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
}



- (void) updateTimeDisplay
{
    self.timerLabel.text = [self.model timeTraveled];
}

- (IBAction)endTrip:(id)sender
{
    [self.model timeTripEnded:self.timerLabel.text];        // save stopped trip time 
    [self.model stopTimer];
}


@end
