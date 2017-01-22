//
//  MemberViewController.m
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "MemberViewController.h"
#import "SelectManagerModel.h"
#import "SelectManagerCell.h"
#import "AFNetworking.h"
#import "UIImage+AFNetworking.h"
#import "UIImageView+WebCache.h"
@interface MemberViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MemberViewController
{
    NSString* ProjectId;
    
    UITableView* MemberTable;
    
    NSMutableArray* Datasource;
}

- (instancetype)initWithProjectId:(NSString *)projectId{
    self=[super init];
    if(self){
        ProjectId=projectId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"成员";
    
    [self initData];
    
    [self initTableView];
}

-(void)backBtnClicked{
    if (_backVC) {
        [_backVC backBtnClicked];
    }
    else{
        [super backBtnClicked];
    }
}

- (void)initData
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* TempString=[UserDefaults objectForKey:@"user"];
    
    [dic setObject:ProjectId forKey:@"projectId"];
    [dic setObject:TempString forKey:@"phone"];
    
    [HTTP_MANAGER startNormalPostWithParagram:dic Commandtype:@"app/project/getMembers" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        if (isSucceed) {
            Datasource=[[NSMutableArray alloc]init];
            NSMutableArray* Responser=[[NSMutableArray alloc]init];
            NSMutableArray* Manager=[[NSMutableArray alloc]init];
            NSMutableArray* Operator=[[NSMutableArray alloc]init];
            
            NSMutableArray* arr=[succeedResult objectForKey:@"data"];
            
            for(int i=0;i<arr.count;i++){
                NSDictionary* dic=[arr objectAtIndex:i];
                NSString* usertype=[dic objectForKey:@"userType"];
                if([usertype isEqualToString:@"1"])
                {
                    SelectManagerModel* TempModel=[[SelectManagerModel alloc]init];
                    TempModel.peopleid=[dic objectForKey:@"id"];
                    TempModel.name=[dic objectForKey:@"userName"];
                    TempModel.ImageUrlString=[dic objectForKey:@"photo"];
                    [Responser addObject:TempModel];
                }else if ([usertype isEqualToString:@"2"])
                {
                    SelectManagerModel* TempModel=[[SelectManagerModel alloc]init];
                    TempModel.peopleid=[dic objectForKey:@"id"];
                    TempModel.name=[dic objectForKey:@"userName"];
                    TempModel.ImageUrlString=[dic objectForKey:@"photo"];
                    [Manager addObject:TempModel];
                }else{
                    SelectManagerModel* TempModel=[[SelectManagerModel alloc]init];
                    TempModel.peopleid=[dic objectForKey:@"id"];
                    TempModel.name=[dic objectForKey:@"userName"];
                    TempModel.ImageUrlString=[dic objectForKey:@"photo"];
                    [Operator addObject:TempModel];
                }
            }
            if(Responser.count!=0){
                NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
                [dic setObject:Responser forKey:@"array"];
                [dic setObject:@"项目负责人" forKey:@"header"];
                [Datasource addObject:dic];
            }
            if(Manager.count!=0){
                NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
                [dic setObject:Manager forKey:@"array"];
                [dic setObject:@"支行经办人" forKey:@"header"];
                [Datasource addObject:dic];
            }
            if(Operator.count!=0){
                NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
                [dic setObject:Operator forKey:@"array"];
                [dic setObject:@"投行经办人" forKey:@"header"];
                [Datasource addObject:dic];
            }
            
            [MemberTable reloadData];
        }
        else{
            [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:2];
        }
    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
        [PubllicMaskViewHelper showTipViewWith:@"请求失败，请检查网络设置后重试" inSuperView:self.view withDuration:2];
    }];
    
    
}


- (void)initTableView
{
    //40待定---tabbarheight
    MemberTable=[[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATOR_HEIGHT+STATUS_BAR_HEIGHT+40, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATOR_HEIGHT-STATUS_BAR_HEIGHT-40-TAB_BAR_HEIGHT) style:UITableViewStyleGrouped];
    MemberTable.delegate=self;
    MemberTable.dataSource=self;
    MemberTable.separatorStyle = UITableViewCellEditingStyleNone;
    [self.view addSubview:MemberTable];
}




#pragma mark Table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return Datasource.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSMutableDictionary* dic=[Datasource objectAtIndex:section];
    return [dic objectForKey:@"header"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary* dic=[Datasource objectAtIndex:section];
    NSMutableArray* arr=[dic objectForKey:@"array"];
    return arr.count;
}


// 创建 tableView 的 cell
- ( UITableViewCell *)tableView:( UITableView *)tableView cellForRowAtIndexPath:( NSIndexPath *)indexPath
{
    SelectManagerCell *cell=[SelectManagerCell cellWithTableView:tableView];
    
    NSMutableDictionary* TempDic=[Datasource objectAtIndex:indexPath.section];
    NSMutableArray* TempArr=[TempDic objectForKey:@"array"];
    SelectManagerModel* model=[TempArr objectAtIndex:indexPath.row];
    
    
    cell.SelectedImageView .hidden=YES;
    [cell.NameLabel setText:model.name];
    
    NSURL* imageurl=[NSURL URLWithString:model.ImageUrlString];
    [cell.IconImageView sd_setImageWithURL:imageurl];
    [cell.LineView setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
