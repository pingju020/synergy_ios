//
//  AboutViewController.m
//  Cooperation
//
//  Created by LeonJing on 23/01/2017.
//  Copyright © 2017 Tion. All rights reserved.
//

#import "AboutViewController.h"
#import "PJTabBarItem.h"
#import "LJMacros.h"
#import "UIView+LJAdditions.h"
#import "NSDictionary+LJAdditions.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSDictionary* resultInfos;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    self.title = @"关于";
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#00D2FF"]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    [HTTP_MANAGER startNormalPostWithParagram:@{@"phone":[[NSUserDefaults standardUserDefaults]objectForKey:@"user"],@"origins":@"ios",@"versionCode":@"0"} Commandtype:@"app/version/checkVersion" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        @strongify(self)
        self.resultInfos = [succeedResult lj_dictionaryForKey:@"data"];
        [self.tableView reloadData];
    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
        
    }];
}

- (void) dealloc
{
}

- (void)loadView{
    [super loadView];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleAll;
    [self.view addSubview:_tableView];
    
    self.tableView.tableHeaderView = [self tableViewHeader];
}

- (UIView*) tableViewHeader{
    UIView* v = [[UIView alloc]initWithFrame:(CGRect){0,0,SCREEN_WIDTH,240.f}];
    
    UIImageView* iv = [[UIImageView alloc]initWithFrame:(CGRect){0}];
    iv.image = [UIImage imageNamed:@"ios120"];
    [v addSubview:iv];
    iv.lj_width = 50;
    iv.lj_height = 50;
    iv.center = v.center;
    
    
    UILabel* l = [[UILabel alloc]init];
    l.textAlignment =  NSTextAlignmentCenter;
    l.text = [NSString stringWithFormat:@"v%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [v addSubview:l];
    l.lj_width = v.lj_width;
    l.lj_height = 20;
    l.lj_centerX = v.lj_centerX;
    l.lj_top = iv.lj_bottom;
    
    return v;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = 44;
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
            break;
        }
        case 3:
        {
            break;
        }
        default:
            break;
    }
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = @"";
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"检查更新";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"最新版本%@",[self.resultInfos lj_stringForKey:@"version"]];
            break;
        }
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImageView* ac = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"右箭头"]];
            ac.lj_width = 8;
            ac.lj_height = ac.lj_width*1.5;
            cell.accessoryView = ac;
            cell.textLabel.text = @"常见问题";
            //cell.detailTextLabel.text = @"最新版本";
            break;
        }
        case 2:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImageView* ac = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"右箭头"]];
            ac.lj_width = 8;
            ac.lj_height = ac.lj_width*1.5;
            cell.accessoryView = ac;
            cell.textLabel.text = @"版权信息";
            //cell.detailTextLabel.text = @"最新版本";
            break;
        }
        case 3:
        {
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            NSString* sURL = [self.resultInfos lj_stringForKey:@"url"];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:sURL]];
            //[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.pgyer.com/djde"]];
            break;
        }
        case 1:
        {
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
