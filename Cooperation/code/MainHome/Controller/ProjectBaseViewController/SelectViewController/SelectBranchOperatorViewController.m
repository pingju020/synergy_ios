//
//  SelectBranchOperatorViewController.m
//  Cooperation
//
//  Created by Tion on 17/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "SelectBranchOperatorViewController.h"
#import "SelectManagerCell.h"
#import "UIImageView+WebCache.h"
#import "SelectBranchOperatorModel.h"
@interface SelectBranchOperatorViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SelectBranchOperatorViewController
{
    NSString* BranchId;
    
    UITableView* MemberTable;
    
    NSMutableArray* Datasource;
    
    NSMutableArray* HeaderDatasource;
}

- (instancetype)initWithBranchId:(NSString *)branchId{
    self=[super init];
    if(self){
        BranchId=branchId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"成员";
    
    [self initData];
    
    [self initTableView];

    
    [self SetConfirmButton];
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


-(void)backBtnClicked{
//    if (_backVC) {
//        [_backVC backBtnClicked];
//    }
//    else{
//        [super backBtnClicked];
//    }
}

- (void)initData
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* TempString=[UserDefaults objectForKey:@"user"];
    
    [dic setObject:BranchId forKey:@"officeId"];
    [dic setObject:TempString forKey:@"phone"];
    
    [HTTP_MANAGER startNormalPostWithParagram:dic Commandtype:@"app/project/getOperatorUser" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        if (isSucceed) {
            Datasource=[[NSMutableArray alloc]init];
            HeaderDatasource=[[NSMutableArray alloc]init];
            
            NSMutableArray* arr=[succeedResult objectForKey:@"data"];
            
            for(int i=0;i<arr.count;i++)
            {
                NSDictionary* TempDic=[arr objectAtIndex:i];
                
                NSString* TempString=[TempDic objectForKey:@"officeName"];
                NSMutableArray* TempArray=[TempDic objectForKey:@"userViewList"];
                for(int i=0;i<TempArray.count;i++){
                    NSMutableDictionary* dic=[TempArray objectAtIndex:i];
                    [dic setObject:@"NO" forKey:@"Mark"];
                }
                [HeaderDatasource addObject:TempString];
                
                [Datasource addObject:TempArray];
                
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
//    NSMutableDictionary* dic=[Datasource objectAtIndex:section];
    
    return [HeaderDatasource objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray* array=[Datasource objectAtIndex:section];
    return array.count;
}


// 创建 tableView 的 cell
- ( UITableViewCell *)tableView:( UITableView *)tableView cellForRowAtIndexPath:( NSIndexPath *)indexPath
{
    SelectManagerCell *cell=[SelectManagerCell cellWithTableView:tableView];
    
    NSMutableArray* TempArray=[Datasource objectAtIndex:indexPath.section];
    NSDictionary* dic=[TempArray objectAtIndex:indexPath.row];
    
//    NSMutableArray* TempArr=[TempDic objectForKey:@"userViewList"];
//    NSDictionary* model=[TempArr objectAtIndex:indexPath.row];
    
    
    NSString* name=[dic objectForKey:@"userName"];
    NSString* mark=[dic objectForKey:@"Mark"];
    NSString* imageUrl=[dic objectForKey:@"photo"];
    if([mark isEqualToString:@"YES"]){
        [cell.SelectedImageView setImage:[UIImage imageNamed:@"selected@3x.png"]];
        
    }
    else{
        [cell.SelectedImageView setImage:[UIImage imageNamed:@"unselected@3x.png"]];
    }
    [cell.NameLabel setText:name];
    [cell.IconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    [cell.LineView setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
    
    return cell;//cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray* TempArray=[Datasource objectAtIndex:indexPath.section];
    NSMutableDictionary* TempDic=[TempArray objectAtIndex:indexPath.row];
    if([[TempDic objectForKey:@"Mark"]isEqualToString:@"YES"]){
        [TempDic setObject:@"NO" forKey:@"Mark"];
    }else
    {
        [TempDic setObject:@"YES" forKey:@"Mark"];
    }
    
    [MemberTable reloadData];
}

- (void)ConfirmThePeople
{
    NSMutableArray* arr=[[NSMutableArray alloc]init];
    
    for(int i=0;i<Datasource.count;i++){
        NSMutableArray* TempArray=[Datasource objectAtIndex:i];
        for(int j=0;j<TempArray.count;j++){
            NSMutableDictionary* TempDic=[TempArray objectAtIndex:j];
            if([[TempDic objectForKey:@"Mark"]isEqualToString:@"YES"])
            {
                [arr addObject:TempDic];
            }
        }
        
    }
    [self.delegate SelectBranchOperator:arr];
    [self dismissViewControllerAnimated:NO completion:^{}];
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
