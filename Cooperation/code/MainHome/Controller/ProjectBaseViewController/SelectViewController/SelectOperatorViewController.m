//
//  SelectOperatorViewController.m
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "SelectOperatorViewController.h"
#import "SelectManagerModel.h"
#import "SelectManagerCell.h"
#import "HttpSessionManager.h"
#import "AFNetworking.h"

@interface SelectOperatorViewController ()<UITableViewDataSource,UITableViewDelegate>

@end


@implementation SelectOperatorViewController
{
    BOOL IsManager;
    UITableView* SelectTable;
    
    NSMutableArray* DataSource;
}
- (instancetype)initWithSelectType:(NSString*)type
{
    //新建项目选择管理者
    if([type isEqualToString:@"manager"])
    {
        
        IsManager=YES;
        
    }else//项目领导人选择经办人
    {
        IsManager=NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SetTitle];
    
    [self initTableView];
    
    [self GetData];
    
    [self SetConfirmButton];
    
    
}

//设置title
- (void)SetTitle{
    if(IsManager==YES){
        self.title=@"选择项目负责人";
    }
    else{
        self.title=@"选择项目经办人";
    }
}

//获取数据
- (void)GetData{
//    DataSource=[[NSMutableArray   alloc]init];
    
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* TempString=[UserDefaults objectForKey:@"user"];
    
    [dic setObject:TempString forKey:@"phone"];
    
    [HTTP_MANAGER startNormalPostWithParagram:dic Commandtype:@"app/project/getNeedUser" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        if (isSucceed) {
            NSArray* arr=[succeedResult objectForKey:@"data"];
            DataSource=[[NSMutableArray alloc]init];
            for(int i=0;i<arr.count;i++)
            {
                NSMutableDictionary* dic=[arr objectAtIndex:i];
                SelectManagerModel* TempModel=[[SelectManagerModel alloc]initWithDic:dic];
                [DataSource addObject:TempModel];
            }
            [SelectTable reloadData];
        }
        else{
            [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:2];
        }
    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
        [PubllicMaskViewHelper showTipViewWith:@"请求失败，请检查网络设置后重试" inSuperView:self.view withDuration:2];
    }];
    
}

//初始化表格
- (void)initTableView{
    SelectTable=[[UITableView alloc]initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT*5/6-STATUS_BAR_HEIGHT-NAVIGATOR_HEIGHT)];
    SelectTable.separatorStyle = UITableViewCellEditingStyleNone;
    [self.view addSubview:SelectTable];
    
    SelectTable.delegate=self;
    SelectTable.dataSource=self;
}

- (void)SetConfirmButton{
    
    UIButton* ConfirmButton=[[UIButton alloc]initWithFrame:CGRectMake(20,SCREEN_HEIGHT-60-30, SCREEN_WIDTH-40, 60)];
    ConfirmButton.layer.masksToBounds=YES;
    ConfirmButton.layer.cornerRadius=30;
    
    [ConfirmButton setBackgroundColor:[UIColor colorWithHexString:@"#3788D0"]];
    [ConfirmButton addTarget:self action:@selector(ConfirmThePeople) forControlEvents:UIControlEventTouchUpInside];
    [ConfirmButton setTitle:@"确 认" forState:UIControlStateNormal];
    
    [self.view addSubview:ConfirmButton];
}


#pragma mark table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return DataSource.count;
}


// 创建 tableView 的 cell
- ( UITableViewCell *)tableView:( UITableView *)tableView cellForRowAtIndexPath:( NSIndexPath *)indexPath
{
    
//        ProjectMessageCell* cell=[ProjectMessageCell cellWithTableView:tableView];
//        
//        ProjectMessageModel* TempModel=[Datasource objectAtIndex:indexPath.row];
//        
//        [cell.MessgaeLabel setText:TempModel.projectName];
//        [cell.StatusLabel setText:TempModel.stageName];
    
    SelectManagerCell *cell=[SelectManagerCell cellWithTableView:tableView];
    
    SelectManagerModel* model=[DataSource objectAtIndex:indexPath.row];
    
    [cell.NameLabel setText:model.name];
    if(model.Mark==YES){
        [cell.SelectedImageView setImage:[UIImage imageNamed:@"selected@3x.png"]];
    }
    else{
        [cell.SelectedImageView setImage:[UIImage imageNamed:@"unselected@3x.png"]];
    }

    
    return cell;
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for(int i=0;i<DataSource.count;i++){
        if(i==indexPath.row)
        {
            SelectManagerModel* model=[DataSource objectAtIndex:i];
            model.Mark=YES;
        }
        else{
            SelectManagerModel* model=[DataSource objectAtIndex:i];
            model.Mark=NO;
        }
    }
    [SelectTable reloadData];
}

#pragma mark 点击事件
- (void)ConfirmThePeople
{
    for(int i=0;i<DataSource.count;i++)
    {
        SelectManagerModel* model=[DataSource objectAtIndex:i];
        if(model.Mark==YES)
        {
            [self.delegate chooseOperatorOrManagerWithName:model.name AndId:model.peopleid];
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
