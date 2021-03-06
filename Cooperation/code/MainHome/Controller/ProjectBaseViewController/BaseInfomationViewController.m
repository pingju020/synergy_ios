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
#import "BackMoneyTableViewCell.h"
#import "SelectOperatorViewController.h"
#import "NSObject+MJKeyValue.h"
#import "SelectFinancialViewController.h"
#import "SelectBankOperateViewController.h"
#import "SelectBranchOperatorViewController.h"


@interface BaseInfomationViewController ()<UITableViewDelegate,UITableViewDataSource,ChoosePeopleDelegate,TextPassValue,NumberPassValue,ChoosePassValue,AddPassValue,BankMoneyPassValue,SelectFinancialModel,SelectBankModel,SelectBranchOperatorModel>
@property(nonatomic,assign)E_INFO_TYPE type;
@property(nonatomic,strong)ProjectDetailModel* model;
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSString* projectName;
@property(nonatomic,strong)NSArray* listData;
@property(nonatomic,strong)NSArray*  creditList;
@property(nonatomic,strong)UIView* headerView;

// 上不固定的list数据
@property(nonatomic,strong)NSArray* list;
@end

@implementation BaseInfomationViewController
{
    NSString* branchId;
    NSMutableDictionary* paramsDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    title.text = self.projectName;
    paramsDic=[[NSMutableDictionary alloc]init];
    if (_type == E_INFO_EDIT) {
        [self.tableView reloadData];
    }
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

-(id)initWithProjectId:(NSString*)projectId ProjectName:(NSString*)projectName type:(E_INFO_TYPE)type{
    if (self = [super init]) {
        _type = type;
        _projectName = projectName;
//        if (type == E_INFO_EDIT) {
//            _model = [[ProjectDetailModel alloc]init];
//            title.text = @"填写项目基本信息";
//            [self makeListData];
//        }
//        else{
            NSDictionary* para = @{
                                   @"phone":[[NSUserDefaults standardUserDefaults]objectForKey:@"user"],
                                   @"projectId":projectId};
            [HTTP_MANAGER startNormalPostWithParagram:para Commandtype:@"app/project/getProjectInfo" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                if (isSucceed) {
                    NSDictionary* tempdic=[succeedResult objectForKey:@"data"];
                    NSArray* arr=[tempdic objectForKey:@"factors"];
                    if(arr.count==0){
                        //为空
                        _type=E_INFO_EDIT;
//                        _model = [[ProjectDetailModel alloc]init];
//                        title.text = @"填写项目基本信息";
//                        [self makeListData];
                        _model = [ProjectDetailModel creatModelWithDictonary:succeedResult[@"data"]];
                        [self makeListData];
                        title.text = _model.project.projectName;
                        [self.tableView reloadData];
                    }
                    else{
                        //不为空
                        _type=E_INFO_VIEW;
                        _model = [ProjectDetailModel creatModelWithDictonary:succeedResult[@"data"]];
                        [self makeListData];
                        title.text = _model.project.projectName;
                        [self.tableView reloadData];
                    }
                    
                    
                    
                }
                else{
                    [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:2];
                }
            } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                [PubllicMaskViewHelper showTipViewWith:@"请求失败，请稍后再试" inSuperView:self.view withDuration:2];
            }];
//        }
    }
    return self;
}

-(UIView*)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 56)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 44)];
        [lab setFont:[UIFont systemFontOfSize:14]];
        [lab setTextColor:[UIColor darkGrayColor]];
        [lab setTextAlignment:NSTextAlignmentLeft];
        lab.numberOfLines = 0;
        [lab setText:@"基本信息"];
        [_headerView addSubview:lab];
        
        UIView* sep = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame), MAIN_WIDTH, 56-CGRectGetMaxY(lab.frame))];
        sep.backgroundColor = VcBackgroudColor;
        [_headerView addSubview:sep];
    }
    return _headerView;
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

-(void)makeListData{
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    FactorModel* projectName = [[FactorModel alloc]init];
    projectName.name = @"项目名称";
    projectName.projectContentValue = _model.project.projectName;
    if (_type == E_INFO_EDIT) {
//        projectName.type = @"text";
        projectName.type=@"show";
    }
    else{
        projectName.type = @"show";
    }
    
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
    if (_type == E_INFO_EDIT) {
        financingModeName.projectContentValue = _model.project.financingModeName;
        financingModeName.type = @"date";
        financingModeName.parentVC = self;
        financingModeName.action = @selector(chooseFinace);
    }
    else{
        financingModeName.projectContentValue = _model.project.financingModeName;
        financingModeName.type = @"show";
    }
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
    SelectOperatorViewController* vc = [[SelectOperatorViewController alloc]initWithSelectType:@"manager"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:NO completion:^{}];
}

// 添加经办支行
-(void)addOffice{
    //跳转
    SelectBankOperateViewController* bankOperate=[[SelectBankOperateViewController alloc]init];
    bankOperate.delegate=self;
    [self presentViewController:bankOperate animated:NO completion:^{}];
}

// 添加经办人
-(void)addUser{
    SelectBranchOperatorViewController* vc=[[SelectBranchOperatorViewController alloc]initWithBranchId:branchId];
    vc.delegate=self;
    [self presentViewController:vc animated:NO completion:^{}];
    
//    SelectOperatorViewController* vc = [[SelectOperatorViewController alloc]initWithSelectType:@""];
//    [self.navigationController pushViewController:vc animated:YES];
}

// 添加放款详情
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

//选择融资模式
-(void)chooseFinace{
    //跳转
    SelectFinancialViewController* fin=[[SelectFinancialViewController alloc]init];
    fin.delegate=self;
    [self presentViewController:fin animated:NO completion:^{}];
    
    
    
    //融资模式
    
//    _model.project.financingModeName---1
//    _model.factors---2
    
    //主要设置这个东西
    

    
    //获取融资信息
    NSLog(@"chooseFinace");
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _list.count;
    }
    else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 56;
    }
    else{
        return 44;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 56;
    }
    else{
        return 44;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return self.headerView;
    }
    else{
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 44)];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        FactorModel* model = _list[indexPath.row];
        if ([model.type isEqualToString:@"text"]|| [model.type isEqualToString:@"show"]) {
            static NSString *textCell = @"textCell";
            TextTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCell];
            if (!cell) {
                cell = [[TextTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCell];
            }
            cell.delegate=self;
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
            cell.delegate=self;
            return cell;
        }
        else if([model.type isEqualToString:@"date"]){
            static NSString *dateCell = @"dateCell";
            ChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dateCell];
            
            if (!cell) {
                cell = [[ChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dateCell];
            }
            cell.model = model;
            cell.delegate=self;
            return cell;
        }
        else{
            static NSString *cellIdentifier = @"cellIdentifier";
            AddButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell) {
                cell = [[AddButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.model = model;
            cell.delegate=self;
            return cell;
        }
    }
    else{
        static NSString *cellIdentifier = @"cellIdentifierAddtional";
        BackMoneyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        CreditModel* model = _creditList[indexPath.row];
        if (!cell) {
            cell = [[BackMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if (indexPath.row == 0) {
            cell.isTableHeader = YES;
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

#pragma mark -- ChoosePeopleDelegate
-(void)chooseOperatorOrManagerWithName:(NSString*)name AndId:(NSString*)peopleid{
    ;
}

#pragma mark 代理传值
-(void)PassValue:(NSString *)Text{
    
    //存储值
    NSLog(@"text=%@",Text);
}

- (void)NumberPassValue:(NSString*)Text{
    //存储值
     NSLog(@"text=%@",Text);
}

- (void)ChoosePassValue:(NSString*)Text{
    //存储值
     NSLog(@"text=%@",Text);
}

- (void)AddPassValue:(NSString *)Text{
    //存储值
     NSLog(@"text=%@",Text);
}

-(void)BankMoneyPassValue:(NSString *)Text{
    //存储值
     NSLog(@"text=%@",Text);
}

-(void)SelectFinancialModel:(NSMutableDictionary *)financialDic{
    //发起请求重置并填充值
    NSLog(@"fin=%@",financialDic);
    
    _model.project.financingModeName=[financialDic objectForKey:@"txt"];
    
    NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
    
    //    NSMutableDictionary* dic=[NSMutableDictionary new];
    //
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* TempString=[UserDefaults objectForKey:@"user"];
    [dic setObject:TempString forKey:@"phone"];
    [dic setObject:[financialDic objectForKey:@"val"] forKey:@"financialId"];
    
    [HTTP_MANAGER startNormalPostWithParagram:dic Commandtype:@"app/project/getFactors" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        if (isSucceed) {
            NSLog(@"issec=%@",succeedResult);
            //            NSDictionary* dic=[succeedResult objectForKey:@"result"];
            //                    NSMutableArray* arr=[succeedResult objectForKey:@"data"];
            
            
            NSArray *factors = succeedResult[@"data"];
            
            NSMutableArray *mulArr = [NSMutableArray array];
            
            for (NSDictionary *dict in factors) {
                FactorModel *model = [FactorModel mj_objectWithKeyValues:dict];
                model.factorId        = dict[@"id"];
                [mulArr addObject:model];
            }
            _model.factors=mulArr;
            [self makeListData];
            [self.tableView reloadData];
        }
        else{
            [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:2];
        }
    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
        [PubllicMaskViewHelper showTipViewWith:@"请求失败，请稍后再试" inSuperView:self.view withDuration:2];
    }];
}


-(void)SelectBankModel:(NSMutableDictionary *)bankDic{
    //重新初始化
    _model.office=[[OfficeModel alloc]init];
    _model.office.officeName=[bankDic objectForKey:@"txt"];
    branchId=[bankDic objectForKey:@"val"];
    [self makeListData];
    [self.tableView reloadData];
}

-(void)SelectBranchOperator:(NSMutableArray *)bankArray{
    NSString* str=@"";
    for(int i=0;i<bankArray.count;i++){
        NSDictionary* dic=[bankArray objectAtIndex:i];
        NSString* tempstr=[dic objectForKey:@"userName"];
        str=[NSString stringWithFormat:@"%@,%@",str,tempstr];
    }
    _model.userNames=str;
    [self makeListData];
    [self.tableView reloadData];
//    _model.userNames
}


@end
