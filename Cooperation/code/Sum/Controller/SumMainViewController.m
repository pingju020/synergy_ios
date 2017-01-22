//
//  SumMainViewController.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/20.
//  Copyright © 2017年 yangjuanping. All rights reserved.
//

#import "SumMainViewController.h"
#import "PJTabBarItem.h"

#import "SumHeader.h"
#import "LJMacros.h"
#import "UIView+LJAdditions.h"
#import "NSString+LJAdditions.h"
#import "NSDate+LJAdditions.h"
#import "NSDictionary+LJAdditions.h"
#import "JHRingChart.h"
#import "SumLineChart.h"

@interface SumMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) SumHeader* sumHeader;
@property (nonatomic,strong) SumLineChart* lineChart;
@property (nonatomic,strong) JHRingChart* ringChart;
@property (nonatomic,strong) NSDate* dateCurrent;
@property (nonatomic,strong) NSDictionary* resultInfos;
@end

@implementation SumMainViewController

AH_BASESUBVCFORMAINTAB_MODULE

- (void) dealloc
{
}

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleAll;
    [self.view addSubview:_tableView];
    
    
}

- (void) showWithDate:(NSDate*)date{
    @weakify(self)
    
    if (nil == date) {
        date = [NSDate date];
    }
    
    self.dateCurrent = date;
    
    
    
    [HTTP_MANAGER startNormalPostWithParagram:@{@"phone":[[NSUserDefaults standardUserDefaults]objectForKey:@"user"],@"date":[date lj_stringWithFormat:@"yyyy-MM"]} Commandtype:@"app/project/getGatherDate" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        NSNumber* ret =  [succeedResult lj_numberForKey:@"ret"];
        if ([ret isEqualToNumber:@0]) {
            //成功
            @strongify(self)
            self.resultInfos = [succeedResult lj_dictionaryForKey:@"data"];
            [self.tableView reloadData];
        }
    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
        
    }];
}

- (void) reloadData{
    [self showWithDate:[NSDate date]];
}

- (void) showPrev{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:self.dateCurrent options:0];
    [self showWithDate:newDate];
}

- (void) showNext{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:self.dateCurrent options:0];
    [self showWithDate:newDate];
}

- (void) getMonths:(NSArray**)months money:(NSArray**)money{
    NSMutableArray* m0 = @[].mutableCopy;
    NSMutableArray* m1 = @[].mutableCopy;
    NSArray* monthsMoneys = [self.resultInfos lj_arrayForKey:@"monthsMoneys"];
    for (NSDictionary* it in monthsMoneys) {
        [m0 addObject:[it lj_stringForKey:@"month" default:@""]];
        [m1 addObject:[it lj_stringForKey:@"money" default:@""]];
    }
    *months = m0;
    *money = m1;
}

- (NSString*) getProjectStateNum:(NSNumber*)pid{
    NSString* ret = @"";
    NSArray* projectState = [self.resultInfos lj_arrayForKey:@"projectState"];
    for (NSDictionary* it in projectState) {
        if ([[it lj_numberForKey:@"stateId"]isEqualToNumber:pid]) {
            ret = [it lj_stringForKey:@"num"];
            break;
        }
    }
    return ret;
}

- (NSString*) getStateNum:(NSNumber*)pid{
    NSString* ret = @"";
    NSArray* stateNum = [self.resultInfos lj_arrayForKey:@"stateNum"];
    for (NSDictionary* it in stateNum) {
        if ([[it lj_numberForKey:@"stateId"]isEqualToNumber:pid]) {
            ret = [it lj_stringForKey:@"num"];
            break;
        }
    }
    return ret;
}
- (NSString*) getStateName:(NSNumber*)pid{
    NSString* ret = @"";
    NSArray* stateNum = [self.resultInfos lj_arrayForKey:@"stateNum"];
    for (NSDictionary* it in stateNum) {
        if ([[it lj_numberForKey:@"stateId"]isEqualToNumber:pid]) {
            ret = [it lj_stringForKey:@"stateName"];
            break;
        }
    }
    return ret;
}

- (NSArray*) getStateValues{
    NSMutableArray* ret = @[].mutableCopy;
    NSArray* s = @[@1,@2,@3,@4,@0];
    for (NSNumber* si in s) {
        [ret addObject:[self getStateNum:si]];
    }
    return ret;
}
- (NSArray*) getStateDescs{
    NSMutableArray* ret = @[].mutableCopy;
    NSArray* s = @[@1,@2,@3,@4,@0];
    for (NSNumber* si in s) {
        [ret addObject:[self getStateName:si]];
    }
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"汇总";
    
    [self reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.tableView.lj_width = self.view.lj_width;
    self.tableView.lj_height = self.view.lj_height - HEIGHT_NAVIGATION - HEIGHT_MAIN_BOTTOM;
    self.tableView.lj_top = HEIGHT_NAVIGATION;
    self.tableView.lj_centerX =  self.view.lj_centerX;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(PJTabBarItem*)getTabBarItem{
    //
    PJTabBarItem* itemMainHome = [[PJTabBarItem alloc]init];
    itemMainHome.strTitle = @"汇总";
    itemMainHome.strNormalImg = @"sum@2x.png";
    itemMainHome.strSelectImg = @"sum_press@2x.png";
    itemMainHome.viewController = self;
    itemMainHome.tabIndex = 2;
    //title.text = itemMainHome.strTitle;
    [self setTitle:itemMainHome.strTitle];
    return itemMainHome;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = 40;
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    break;
                }
                case 1:
                {
                    break;
                }
                case 2:
                {
                    h = 120;
                    break;
                }
                case 3:
                {
                    break;
                }
                case 4:
                {
                    break;
                }
                case 5:
                {
                    break;
                }
                case 6:
                {
                    h = 200;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self)
    
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:43/255.f green:185/255.f blue:244/255.f alpha:1];
    
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    
                    SumHeader* header = [[SumHeader alloc]initWithFrame:cell.contentView.bounds];
                    header.onDidSelectedAtLeft = ^{
                        @strongify(self)
                        [self showPrev];
                    };
                    header.onDidSelectedAtRight = ^{
                        @strongify(self)
                        [self showNext];
                    };
                    
                    [cell.contentView addSubview:header];
                    
                    header.labelDate.text = [self.dateCurrent lj_stringWithFormat:@"yyyy年MM月"];
                    
                    break;
                }
                case 1:
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = @"已放款";
                    cell.detailTextLabel.text = @"12亿";
                    break;
                }
                case 2:
                {
                    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    
                    NSArray* vArray = nil;
                    NSArray* dArray = nil;
                    [self getMonths:&vArray money:&dArray];
                    
                    SumLineChart* lineChart = [[SumLineChart alloc]initWithFrame:(CGRect){0,0,self.view.lj_width,120}];
                    lineChart.backgroundColor = [UIColor whiteColor];
                    lineChart.descArray = dArray;//@[@"8月",@"9月",@"10月",@"11月",@"12月",@"1月"];
                    [lineChart drawLineChartWithValueArray:vArray/*@[@10,@11,@10.5,@10.8,@14,@12]*/ lineWidth:3.0 lineColor:[UIColor colorWithRed:26/255.f green:176/255.f blue:241/255.f alpha:1.f] lineJionStyle:LPLineJoinRound lineJoinPointColor:[UIColor colorWithRed:26/255.f green:176/255.f blue:241/255.f alpha:1.f] lineJoinPointWidth:5.0 topPadding:50 rightPadding:10 bottomPadding:50 leftPadding:10 valueSituation:LPValueSituationTop prefixString:@"" suffixString:@"亿" valueStringPadding:10 valueTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:(10)]}];
                    
                    [cell.contentView addSubview:lineChart];
                    break;
                }
                case 3:
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    UIImageView* ac = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"右箭头"]];
                    ac.lj_width = 8;
                    ac.lj_height = ac.lj_width*1.5;
                    cell.accessoryView = ac;
                    cell.textLabel.text = @"已完成";
                    cell.detailTextLabel.text = [self getProjectStateNum:@2];
                    break;
                }
                case 4:
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    UIImageView* ac = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"右箭头"]];
                    ac.lj_width = 8;
                    ac.lj_height = ac.lj_width*1.5;
                    cell.accessoryView = ac;
                    cell.textLabel.text = @"已关闭";
                    cell.detailTextLabel.text = [self getProjectStateNum:@3];
                    break;
                }
                case 5:
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = @"进行中";
                    cell.detailTextLabel.text = [self getProjectStateNum:@1];;
                    break;
                }
                case 6:
                {
                    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    
                    JHRingChart *ring = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 0, self.view.lj_width, 200)];
                    ring.backgroundColor = [UIColor whiteColor];
                    ring.valueDataArr = [self getStateValues];//@[@"12",@"7",@"5",@"13",@"46"];
                    ring.ringWidth = 35.0;
                    ring.fillColorArray = @[[UIColor colorWithHexString:@"#0DBEF5"]
                                            ,[UIColor colorWithHexString:@"#6C85DD"]
                                            ,[UIColor colorWithHexString:@"#09BB07"]
                                            ,[UIColor colorWithHexString:@"#3188DB"]
                                            ,[UIColor colorWithHexString:@"#50E3C2"]];
                    ring.descArr = [self getStateDescs];//@[@"阶段一",@"阶段二",@"阶段三",@"阶段四",@"其他"];
                    [ring showAnimation];
                    
                    [cell.contentView addSubview:ring];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    break;
                }
                case 1:
                {
                    ;
                    break;
                }
                case 2:
                {
                    break;
                }
                case 3:
                {
                    break;
                }
                case 4:
                {
                    
                    break;
                }
                case 5:
                {
                    break;
                }
                case 6:
                {
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
