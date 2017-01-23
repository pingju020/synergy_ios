//
//  SelectFinancialViewController.m
//  Cooperation
//
//  Created by Tion on 17/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "SelectFinancialViewController.h"
#import "SelectManagerCell.h"
#import "SelectManagerModel.h"
@interface SelectFinancialViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SelectFinancialViewController{
    UITableView* SelectTable;
    
    NSMutableArray* DataSource;
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
    
    self.title=@"选择融资模式";
   
}

//获取数据
- (void)GetData{
    NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    [dic setObject:[UserDefaults objectForKey:@"user"] forKey:@"phone"];
    
    [HTTP_MANAGER startNormalPostWithParagram:dic Commandtype:@"app/project/getFinancial" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        if (isSucceed) {
            
            DataSource=[[NSMutableArray alloc]init];
            NSMutableArray* arr=[succeedResult objectForKey:@"data"];
            for(int i=0;i<arr.count;i++)
            {
                NSMutableDictionary* dic=[arr objectAtIndex:i];
                [dic setObject:@"NO" forKey:@"Mark"];
                [DataSource addObject:dic];
            }
            [SelectTable reloadData];
            
        }
        else{
            [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:2];
        }
    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
        [PubllicMaskViewHelper showTipViewWith:@"请求失败，请稍后再试" inSuperView:self.view withDuration:2];
    }];
    
    
    
//    
//    NSMutableDictionary* dic=[NSMutableDictionary new];
//    NSDictionary* tem=[arr objectAtIndex:0];
//    [dic setObject:[tem objectForKey:@"val"] forKey:@"financialId"];
//    [dic setObject:[UserDefaults objectForKey:@"user"] forKey:@"phone"];
//    NSMutableDictionary* dic=[NSMutableDictionary new];
//    
//    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
//    NSString* TempString=[UserDefaults objectForKey:@"user"];
//    
//    [dic setObject:TempString forKey:@"phone"];
    
    
    
    //NSArray* arr=[succeedResult objectForKey:@"data"];
//    DataSource=[[NSMutableArray alloc]init];
    
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






#pragma mark TABLE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return DataSource.count;
}


// 创建 tableView 的 cell
- ( UITableViewCell *)tableView:( UITableView *)tableView cellForRowAtIndexPath:( NSIndexPath *)indexPath
{
    
    SelectManagerCell *cell=[SelectManagerCell cellWithTableView:tableView];
    
    NSMutableDictionary* model=[DataSource objectAtIndex:indexPath.row];

//    [cell.NameLabel setText:model.name];
//    if(model.Mark==YES){
//        [cell.SelectedImageView setImage:[UIImage imageNamed:@"selected@3x.png"]];
//    }
//    else{
//        [cell.SelectedImageView setImage:[UIImage imageNamed:@"unselected@3x.png"]];
//    }
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

//
//[HTTP_MANAGER startNormalPostWithParagram:dic Commandtype:@"app/project/getFactors" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
//    if (isSucceed) {
//        NSLog(@"issec=%@",succeedResult);
//        //            NSDictionary* dic=[succeedResult objectForKey:@"result"];
//        //                    NSMutableArray* arr=[succeedResult objectForKey:@"data"];
//        
//        NSArray *factors = succeedResult[@"data"];
//        
//        NSMutableArray *mulArr = [NSMutableArray array];
//        
//        for (NSDictionary *dict in factors) {
//            FactorModel *model = [FactorModel mj_objectWithKeyValues:dict];
//            model.factorId        = dict[@"id"];
//            [mulArr addObject:model];
//        }
//        _model.factors=mulArr;
//        [self makeListData];
//        [self.tableView reloadData];
//    }
//    else{
//        [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:2];
//    }
//} failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
//    [PubllicMaskViewHelper showTipViewWith:@"请求失败，请稍后再试" inSuperView:self.view withDuration:2];
//}];


@end
