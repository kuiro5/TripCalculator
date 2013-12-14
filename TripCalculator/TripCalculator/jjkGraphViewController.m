//
//  jjkGraphViewController.m
//  TripCalculator
//
//  Created by Joshua Kuiros on 12/5/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkGraphViewController.h"
#import "jjkCostViewController.h"
#import "jjkComprehensiveViewController.h"
#define LABEL_OFFSET 100

@interface jjkGraphViewController ()

@property (strong, nonatomic) CPTGraphHostingView *hostView;
@property (strong, nonatomic) CPTTheme *selectedTheme;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) NSMutableArray *totalCostSum;
@property (strong, nonatomic) CPTGraph *mainGraph;
@property (strong, nonatomic) CPTPieChart *pieChart;

-(void)initPlot;
-(void)configureHost;
-(void)configureGraph;
-(void)configureChart;
-(void)configureLegend;

@end

//static BOOL startTimer = YES;

@implementation jjkGraphViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _model = [Model sharedInstance];
        }
    return self;
}

#pragma mark - UIViewController lifecycle methods
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // The plot is initialized here, since the view bounds have not transformed for landscape until now
    self.totalCostSum = [self.model totalsArray];
    [self initPlot];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.totalCostSum = [[NSMutableArray alloc] init];
    self.totalCostSum = [self.model totalsArray];
    
    if(startTimer)
    {
        [self.model startTimer];
        startTimer = NO;
    }
}

#pragma mark - Chart behavior
-(void)initPlot {
    //NSLog(@"initplot");
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}

-(void)configureHost {
    //NSLog(@"configurehost");
    
    CGRect parentRect = self.view.bounds;
    //CGSize toolbarSize = self.toolbar.bounds.size;
    parentRect = CGRectMake(parentRect.origin.x,
                            parentRect.origin.y + LABEL_OFFSET,
                            parentRect.size.width,
                            parentRect.size.height - LABEL_OFFSET - 175.0);
    // 2 - Create host view
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
    //self.hostView.backgroundColor = [UIColor clearColor];
    //self.hostView.alpha = 0.6;
    self.hostView.allowPinchScaling = NO;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph {
    //NSLog(@"configuregraph");
    // 1 - Create and initialize graph
    //CGRect *newFrame = [CGRectMake(0.0, 0.0, self.hostView.bounds.size.width, self.hostView.bounds.size.height-175.0)]
    //CGRect newRect = CGRectMake(0.0, 0.0, self.hostView.bounds.size.width, self.hostView.bounds.size.height-500.0);
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
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor orangeColor];
    textStyle.fontName = @"Noteworthy";
    textStyle.fontSize = 28.0f;
    // 3 - Configure title
    NSString *title = @"Cost Guide";
    self.mainGraph.title = title;
    self.mainGraph.titleTextStyle = textStyle;
    self.mainGraph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    self.mainGraph.titleDisplacement = CGPointMake(0.0f, -10.0f);
    // 4 - Set theme
    self.selectedTheme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [self.mainGraph applyTheme:self.selectedTheme];
}

-(void)configureChart {
    // 1 - Get reference to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create chart
    self.pieChart = [[CPTPieChart alloc] init];
    self.pieChart.dataSource = self;
    self.pieChart.delegate = self;
    self.pieChart.backgroundColor = [[UIColor clearColor] CGColor];
    self.pieChart.borderColor = [[UIColor clearColor] CGColor];
    self.pieChart.pieRadius = (self.hostView.bounds.size.width * 0.7) / 3;
    self.pieChart.identifier = graph.title;
    self.pieChart.startAngle = M_PI_4;
    self.pieChart.sliceDirection = CPTPieDirectionClockwise;
    // 3 - Create gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    self.pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    // 4 - Add chart to graph    
    [graph addPlot:self.pieChart];
}

-(void)configureLegend
{
    // 1 - Get graph instance
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create legend
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    // 3 - Configure legend
    theLegend.numberOfColumns = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    // 4 - Add legend to graph
    graph.legend = theLegend;
    graph.legendAnchor = CPTRectAnchorBottomRight;
    CGFloat legendPadding = -(self.view.bounds.size.width / 100);
    graph.legendDisplacement = CGPointMake(legendPadding, -legendPadding);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        //NSLog(@"preparing for segue!");
        if([segue.identifier isEqualToString:@"ComprehensiveSegue"])
        {
            jjkComprehensiveViewController *comprehensiveView = segue.destinationViewController;
            comprehensiveView.costType = typeOfCostSelected;
        }
        
}



#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
        //NSLog(@"numofrecordsplot");
    int numberOfRecords = 0;
    
    for(NSDictionary *costSums in self.totalCostSum)
    {
        NSNumber *total = [costSums objectForKey:@"total"];
        
        if([total integerValue] > 0)
        {
            numberOfRecords++;
        }
    }
    
   // NSLog(@"%d", numberOfRecords);
    
    return 4;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
        //NSLog(@"numbforplotfield");
        NSLog(@" INDEX!!!!!! %d", index);
        self.totalCostSum = [self.model totalsArray];
    
    if (CPTPieChartFieldSliceWidth == fieldEnum)
    {

        NSMutableDictionary *costData = [self.totalCostSum objectAtIndex:index];
        NSNumber  *costNumber = [costData objectForKey:@"total"];
        return costNumber;
    }
    return [NSDecimalNumber zero];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    // 1 - Define label text style
    static CPTMutableTextStyle *labelText = nil;
    if (!labelText) {
        labelText= [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor grayColor];
    }
    // 2 - Calculate portfolio total value
    //NSMutableArray *costInformation = [self.model currentCostInformation];
    //NSDictionary *costData = [costInformation objectAtIndex:index];
    NSDecimalNumber *portfolioSum = [NSDecimalNumber zero];
    for (NSDictionary *costData in self.totalCostSum) {
        //NSString *costString = [costData objectForKey:@"money cost"];
        NSNumber  *costNumber = [costData objectForKey:@"total"];
        NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:[costNumber decimalValue]];
        portfolioSum = [portfolioSum decimalNumberByAdding:result];
    }
    
    // 3 - Calculate percentage value
    
    NSDictionary *currentRecord = [self.totalCostSum objectAtIndex:index];
//    NSString *recordCost =
    NSString *typeOfCost = [currentRecord objectForKey:@"type"];
    NSNumber  *recordCostNumber = [currentRecord objectForKey:@"total"];
    NSDecimalNumber *recordDecimal = [NSDecimalNumber decimalNumberWithDecimal:[recordCostNumber decimalValue]];
    
    //NSDecimalNumber *price = [[[CPDStockPriceStore sharedInstance] dailyPortfolioPrices] objectAtIndex:index];
    if([portfolioSum integerValue] != 0 && [recordCostNumber integerValue] != 0)
    {
        NSDecimalNumber *percent = [recordDecimal decimalNumberByDividingBy:portfolioSum];
    // 4 - Set up display label
        NSString *labelValue = [NSString stringWithFormat:@"%0.1f %%", ([percent floatValue] * 100.0f)];
    // 5 - Create and return layer with label text
        return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
    }
    else
    {
        return [[CPTTextLayer alloc] initWithText:nil style:nil];

    }
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    if (index < [self.totalCostSum count])
    {
        NSDictionary *currentDictionary = [self.totalCostSum objectAtIndex:index];
        NSString *currentType = [currentDictionary objectForKey:@"type"];
        return currentType;
    }
    return @"N/A";
}

#pragma mark - UIActionSheetDelegate methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"actionshett");
}

#pragma mark-timer
-(void)viewWillAppear:(BOOL)animated{
    
    self.model.tripTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/60) target:self selector:@selector(updateTimeDisplay) userInfo:nil repeats:YES];

    //[self.mainGraph reloadData];
//    self.totalCostSum = [self.model totalsArray];
//    int count = 0;
//    
//    for(NSMutableDictionary *dictionary in self.totalCostSum)
//    {
//        NSNumber *totalCost = [dictionary objectForKey:@"total"];
//        [self.pieChart
//        
//        count++;
//    }
//    [self.pieChart reloadData];
    
}

- (void) updateTimeDisplay {
    
    self.timerLabel.text = [self.model timeTraveled];
    
}



@end
