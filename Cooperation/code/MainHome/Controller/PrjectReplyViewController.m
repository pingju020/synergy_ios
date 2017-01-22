//
//  PrjectReplyViewController.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "PrjectReplyViewController.h"
#import "ProjectReplyModel.h"
#import "ProjectReplyTableViewCell.h"

@interface PrjectReplyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)UIView* headerView;
@property(nonatomic,strong)ProjectReplyModel* model;
@property(nonatomic,strong)NSString* projectName;
@end

@implementation PrjectReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    title.text = _projectName;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnClicked{
    if (_backVC) {
        [_backVC backBtnClicked];
    }
    else{
        [super backBtnClicked];
    }
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame)+44, MAIN_WIDTH, MAIN_HEIGHT-CGRectGetMaxY(navigationBG.frame)-44) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(UIView*)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 56)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 44)];
        [lab setFont:[UIFont systemFontOfSize:14]];
        [lab setTextColor:[UIColor darkGrayColor]];
        [lab setTextAlignment:NSTextAlignmentLeft];
        lab.numberOfLines = 0;
        [lab setText:@"变更基本信息"];
        [_headerView addSubview:lab];
        
        UIView* sep = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame), MAIN_WIDTH, 56-CGRectGetMaxY(lab.frame))];
        sep.backgroundColor = VcBackgroudColor;
        [_headerView addSubview:sep];
    }
    return _headerView;
}

-(id)initWithProjectId:(NSString*)projectId ProjectName:(NSString*)projectName{
    if (self = [super init]) {
        _projectName = projectName;
        NSDictionary* para = @{
                               @"phone":[[NSUserDefaults standardUserDefaults]objectForKey:@"user"],
                               @"id":@"d7fdff528b6b4178b10c976de45b419e"};
        [HTTP_MANAGER startNormalPostWithParagram:para Commandtype:@"app/project/getAuditDate" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
            if (isSucceed) {
                _model = [ProjectReplyModel creatModelWithDictonary:succeedResult];
                [self.tableView reloadData];
            }
            else{
                [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:2];
            }
        } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
            [PubllicMaskViewHelper showTipViewWith:@"请求异常，请稍后再试" inSuperView:self.view withDuration:2];
        }];
    }
    return self;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.changeList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 56;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ProjectReplyTableViewCell";
    ProjectReplyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    ChangeModel* model = _model.changeList[indexPath.row];
    if (!cell) {
        cell = [[ProjectReplyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setModel:model Name:_model.userName];
    return cell;

}

#pragma mark --  UITableViewDelagete
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
