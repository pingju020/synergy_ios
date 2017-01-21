//
//  BaseInfomationViewController.m
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "BaseInfomationViewController.h"
#import "ProjectDetailModel.h"
#import "TextTypeTableViewCell.h"
#import "NumberTypeTableViewCell.h"
#import "AddButtonTableViewCell.h"
#import "ChooseTableViewCell.h"

@interface BaseInfomationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)E_INFO_TYPE type;
@property(nonatomic,strong)ProjectDetailModel* model;
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSString* projectName;
@property(nonatomic,strong)NSArray* listData;

// 上不固定的list数据
@property(nonatomic,strong)NSArray* list;
@end

@implementation BaseInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    title.text = self.projectName;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithProjectId:(NSString*)projectId ProjectName:(NSString*)projectName type:(E_INFO_TYPE)type{
    if (self = [super init]) {
        _type = type;
        _projectName = projectName;
        if (type == E_INFO_EDIT) {
            ;
        }
        else{
//            NSDictionary* para = @{
//                                   @"phone":[[NSUserDefaults standardUserDefaults]objectForKey:@"user"],
//                                   @"projectId":projectId};
            NSDictionary* para = @{
                                   @"phone":@"13851491149",
                                   @"projectId":@"a8560710625d4392bf525fe8f38bccb6"};
            
            [HTTP_MANAGER startNormalPostWithParagram:para Commandtype:@"app/project/getProjectInfo" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                if (isSucceed) {
                    _model = [ProjectDetailModel creatModelWithDictonary:succeedResult[@"data"]];
                    [self makeListData];
                    title.text = _model.project.projectName;
                    [self.tableView reloadData];
                    
                }
                else{
                    [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:2];
                }
            } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                [PubllicMaskViewHelper showTipViewWith:@"请求失败，请稍后再试" inSuperView:self.view withDuration:2];
            }];
        }
    }
    return self;
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH, MAIN_HEIGHT-CGRectGetMaxY(navigationBG.frame)) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(void)makeListData{
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    FactorModel* projectName = [[FactorModel alloc]init];
    projectName.name = @"项目名称";
    projectName.projectContentValue = _model.project.projectName;
    projectName.type = @"show";
    [listData addObject:projectName];
    
    FactorModel* handlerName = [[FactorModel alloc]init];
    handlerName.name = @"项目负责人";
    handlerName.projectContentValue = _model.project.responsiblePerson;
    handlerName.action = @selector(addResponsiblePerson);
    handlerName.parentVC = self;
    handlerName.type = @"add";
    [listData addObject:handlerName];
    
    FactorModel* office = [[FactorModel alloc]init];
    office.name = @"经办支行";
    office.projectContentValue = _model.office.officeName;
    office.action = @selector(addOffice);
    office.parentVC = self;
    office.type = @"add";
    [listData addObject:office];
    
    FactorModel* userName = [[FactorModel alloc]init];
    userName.name = @"经办人";
    userName.projectContentValue = _model.userNames;
    userName.action = @selector(addUser);
    userName.parentVC = self;
    userName.type = @"add";
    [listData addObject:userName];
    
    FactorModel* financingModeName = [[FactorModel alloc]init];
    financingModeName.name = @"融资模式";
    financingModeName.projectContentValue = _model.project.financingModeName;
    financingModeName.type = @"show";
    [listData addObject:financingModeName];
    
    for (FactorModel* item in _model.factors) {
        item.parentVC = self;
        if ([item.type isEqualToString:@"date"]) {
            item.action = @selector(chooseDate);
        }
    }
    [listData addObjectsFromArray:_model.factors];
    
    FactorModel* backMoneyStatus = [[FactorModel alloc]init];
    backMoneyStatus.name = @"放款状态";
    backMoneyStatus.projectContentValue = _model.project.financingModeName;
    backMoneyStatus.type = @"date";
    backMoneyStatus.parentVC = self;
    backMoneyStatus.action = @selector(chooseBackMomeyStatu);
    [listData addObject:backMoneyStatus];
    
    FactorModel* backMoneyDetail = [[FactorModel alloc]init];
    backMoneyDetail.name = @"放款详情";
    backMoneyDetail.projectContentValue = @"";
    backMoneyDetail.type = @"add";
    backMoneyDetail.parentVC = self;
    backMoneyDetail.action = @selector(addBackMoney);
    [listData addObject:backMoneyDetail];
    
    self.list = listData;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- 回调
// 添加项目负责人
-(void)addResponsiblePerson{
    NSLog(@"addResponsiblePerson");
}

// 添加经办支行
-(void)addOffice{
    NSLog(@"addOffice");
}

// 添加经办人
-(void)addUser{
    NSLog(@"addUser");
}

// 添加返款详情
-(void)addBackMoney{
    NSLog(@"addBackMoney");
}

// 选择放款状态
-(void)chooseBackMomeyStatu{
    NSLog(@"chooseBackMomeyStatu");
}

// 选择日期
-(void)chooseDate{
    ;NSLog(@"chooseDate");
}

//

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FactorModel* model = _list[indexPath.row];
    if ([model.type isEqualToString:@"text"]|| [model.type isEqualToString:@"show"]) {
        static NSString *textCell = @"textCell";
        TextTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCell];
        if (!cell) {
            cell = [[TextTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCell];
        }
        cell.model = model;
        return cell;
    }
    else if([model.type isEqualToString:@"number"]){
        static NSString *numberCell = @"numberCell";
        NumberTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:numberCell];
        
        if (!cell) {
            cell = [[NumberTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:numberCell];
        }
        cell.model = model;
        return cell;
    }
    else if([model.type isEqualToString:@"date"]){
        static NSString *dateCell = @"dateCell";
        ChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dateCell];
        
        if (!cell) {
            cell = [[ChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dateCell];
        }
        cell.model = model;
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"cellIdentifier";
        AddButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            cell = [[AddButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.model = model;
        return cell;
    }
    return nil;
}

#pragma mark --  UITableViewDelagete
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
