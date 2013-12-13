//
//  jjkGraphViewController.m
//  TripCalculator
//
//  Created by Joshua Kuiros on 12/5/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkGraphViewController.h"
#import "jjkCostViewController.h"
#define LABEL_OFFSET 100

@interface jjkGraphViewController ()

@property (strong, nonatomic) CPTGraphHostingView *hostView;
@property (strong, nonatomic) CPTTheme *selectedTheme;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;


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
    [self initPlot];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if(startTimer)
    {
        [self.model startTimer];
        startTimer = NO;
    }
}

#pragma mark - Chart behavior
-(void)initPlot {
    NSLog(@"initplot");
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}

-(void)configureHost {
    NSLog(@"configurehost");
    
    CGRect parentRect = self.view.bounds;
    //CGSize toolbarSize = self.toolbar.bounds.size;
    parentRect = CGRectMake(parentRect.origin.x,
                            parentRect.origin.y + LABEL_OFFSET,
                            parentRect.size.width,
                            parentRect.size.height);
    // 2 - Create host view
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = NO;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph {
    NSLog(@"configuregraph");
    // 1 - Create and initialize graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph = graph;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.axisSet = nil;
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor blackColor];
    textStyle.fontName = @"Noteworthy";
    textStyle.fontSize = 28.0f;
    // 3 - Configure title
    NSString *title = @"Cost Analysis";
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -10.0f);
    // 4 - Set theme
    self.selectedTheme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:self.selectedTheme];
}

-(void)configureChart {
    // 1 - Get reference to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create chart
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = (self.hostView.bounds.size.height * 0.7) / 5;
    pieChart.identifier = graph.title;
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    // 3 - Create gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    // 4 - Add chart to graph    
    [graph addPlot:pieChart];
}

-(void)configureLegend {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        jjkCostViewController *costViewController = segue.destinationViewController;
        //costViewController.delegate = self;
        
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
        NSLog(@"numofrecordsplot");
    
    return [[self.model currentCostInformation] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
        NSLog(@"numbforplotfield");
    if (CPTPieChartFieldSliceWidth == fieldEnum)
    {
        NSMutableArray *costInformation = [self.model currentCostInformation];
        NSDictionary *costData = [costInformation objectAtIndex:index];
        NSString *costString = [costData objectForKey:@"money cost"];
        NSNumber  *costNumber = [NSNumber numberWithInteger: [costString integerValue]];
        return costNumber;
    }
    return [NSDecimalNumber zero];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
        NSLog(@"datalabelforplot");
    // 1 - Define label text style
    static CPTMutableTextStyle *labelText = nil;
    if (!labelText) {
        labelText= [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor grayColor];
    }
    // 2 - Calculate portfolio total value
    NSMutableArray *costInformation = [self.model currentCostInformation];
    //NSDictionary *costData = [costInformation objectAtIndex:index];
    NSDecimalNumber *portfolioSum = [NSDecimalNumber zero];
    for (NSDictionary *costData in costInformation) {
        NSString *costString = [costData objectForKey:@"money cost"];
        NSNumber  *costNumber = [NSNumber numberWithInteger: [costString integerValue]];
        NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:[costNumber decimalValue]];
        portfolioSum = [portfolioSum decimalNumberByAdding:result];
    }
    
    // 3 - Calculate percentage value
    
    NSDictionary *currentRecord = [costInformation objectAtIndex:index];
    NSString *recordCost = [currentRecord objectForKey:@"money cost"];
    NSNumber  *recordCostNumber = [NSNumber numberWithInteger: [recordCost integerValue]];
    NSDecimalNumber *recordDecimal = [NSDecimalNumber decimalNumberWithDecimal:[recordCostNumber decimalValue]];
    
    //NSDecimalNumber *price = [[[CPDStockPriceStore sharedInstance] dailyPortfolioPrices] objectAtIndex:index];
    NSDecimalNumber *percent = [recordDecimal decimalNumberByDividingBy:portfolioSum];
    // 4 - Set up display label
    NSString *labelValue = [NSString stringWithFormat:@"$%0.2f USD (%0.1f %%)", [recordDecimal floatValue], ([percent floatValue] * 100.0f)];
    // 5 - Create and return layer with label text
    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    return @"";
}

#pragma mark - UIActionSheetDelegate methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"actionshett");
}

#pragma mark-timer
-(void)viewWillAppear:(BOOL)animated{
    
    self.model.tripTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/60) target:self selector:@selector(updateTimeDisplay) userInfo:nil repeats:YES];
    
}

- (void) updateTimeDisplay {
    
    self.timerLabel.text = [self.model timeTraveled];
    
}



@end
