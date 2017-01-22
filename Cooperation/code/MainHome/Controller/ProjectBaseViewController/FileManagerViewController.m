//
//  FileManagerViewController.m
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "FileManagerViewController.h"
#import "FileModel.h"
#import "FolderModel.h"
#import "FolderTableCell.h"
#import "FileTableCell.h"
@interface FileManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString* ProjectId;
    
    UITableView* FolderTable;
    UITableView* FileTable;
    
    NSMutableArray* FolderDatasource;
    NSMutableArray* FileDatasource;
    
    BOOL IfisFolder;
    UIButton* ChangeButton;
}
@end

@implementation FileManagerViewController

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
    IfisFolder=YES;
    [self initTopView];
    
    [self initFolderData];
    
    [self initTableView];
    
    
}

#pragma mark 设定表头
- (void)initTopView{
    UIView* backview=[[UIView alloc]initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT+40, SCREEN_WIDTH, 80)];
    [self.view addSubview:backview];
    UIView* TopLine=[[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,10)];
    [TopLine setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
    [backview addSubview:TopLine];
    
    UIView* BottomLine=[[UIView alloc]initWithFrame:CGRectMake(0, 79, SCREEN_WIDTH, 1)];
    [BottomLine setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
    [backview addSubview:BottomLine];
    
    ChangeButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 69)];
    //    [ChangeButton setBackgroundColor:[UIColor whiteColor]];
    [ChangeButton setTitle:@"显示全部文件" forState:UIControlStateNormal];
    [ChangeButton setTitleColor:[UIColor colorWithHexString:@"#00B700"] forState:UIControlStateNormal];
    [ChangeButton addTarget:self action:@selector(ChangeListModel) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:ChangeButton];
    
    
}

#pragma mark 获取文件夹数据
- (void)initFolderData
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* TempString=[UserDefaults objectForKey:@"user"];
    
    [dic setObject:ProjectId forKey:@"projectId"];
    [dic setObject:TempString forKey:@"phone"];
    
    [HTTP_MANAGER startNormalPostWithParagram:dic Commandtype:@"app/file/getFolderList" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        if (isSucceed) {
            NSLog(@"------------------------------ussucceed=%@",succeedResult);
            //文件夹
            FolderDatasource=[[NSMutableArray alloc]init];
            
            NSMutableArray* TempArray=[succeedResult objectForKey:@"data"];
            for(int i=0;i<TempArray.count;i++)
            {
                FolderModel* TempModel=[[FolderModel alloc]init];
                NSDictionary* Dic=[TempArray objectAtIndex:i];
                TempModel.stageModuleName=[Dic objectForKey:@"stageModuleName"];
                TempModel.stageModuleId=[Dic objectForKey:@"stageModuleId"];
                NSNumber* tempnum=[Dic objectForKey:@"num"];
                TempModel.num=[NSString stringWithFormat:@"%@",tempnum];
                [FolderDatasource addObject:TempModel];
            }
            [FolderTable reloadData];
        }
        else{
            [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:2];
        }
    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
        [PubllicMaskViewHelper showTipViewWith:@"请求失败，请检查网络设置后重试" inSuperView:self.view withDuration:2];
    }];
    
    
}

- (void)GetFileDataWithFolderName:(NSString*)stageName{
    
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* TempString=[UserDefaults objectForKey:@"user"];
    
    [dic setObject:ProjectId forKey:@"projectId"];
    [dic setObject:TempString forKey:@"phone"];
    
    if([stageName isEqualToString:@"all"])
    {
        //不设定stageName
    }else{
        //设定stagename
        [dic setObject:stageName forKey:@"stageName"];
    }
    
    
    [HTTP_MANAGER startNormalPostWithParagram:dic Commandtype:@"app/file/getFileList" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        if (isSucceed) {
            FileDatasource=[[NSMutableArray alloc]init];
            NSMutableArray* TempArr=[succeedResult objectForKey:@"data"];
            for(int i=0;i<TempArr.count;i++){
                NSDictionary* dic=[TempArr objectAtIndex:i];
                FileModel* TempModel=[[FileModel alloc]init];
                TempModel.createTime=[dic objectForKey:@"createTime"];
                TempModel.fileName=[dic objectForKey:@"fileName"];
                NSNumber* TempNumber=[dic objectForKey:@"fileType"];
                TempModel.fileType=[NSString stringWithFormat:@"%@",TempNumber];
                TempModel.fileUrl=[dic objectForKey:@"fileUrl"];
                TempModel.fileid=[dic objectForKey:@"id"];
                TempModel.projectId=[dic objectForKey:@"projectId"];
                TempModel.createUserName=[dic objectForKey:@"createUserName"];
                [FileDatasource addObject:TempModel];
            }
            [FileTable reloadData];
            FileTable.hidden=NO;
            FolderTable.hidden=YES;
            [ChangeButton setTitle:@"显示文件夹" forState:UIControlStateNormal];
            
            IfisFolder=NO;
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
    FolderTable=[[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATOR_HEIGHT+STATUS_BAR_HEIGHT+40+80, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATOR_HEIGHT-STATUS_BAR_HEIGHT-40-80)];
    FolderTable.delegate=self;
    FolderTable.dataSource=self;
    FolderTable.separatorStyle = UITableViewCellEditingStyleNone;
    FolderTable.hidden=NO;
    [self.view addSubview:FolderTable];
    
    FileTable=[[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATOR_HEIGHT+STATUS_BAR_HEIGHT+40+80, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATOR_HEIGHT-STATUS_BAR_HEIGHT-40-80)];
    FileTable.delegate=self;
    FileTable.dataSource=self;
    FileTable.separatorStyle = UITableViewCellEditingStyleNone;
    FileTable.hidden=YES;
    [self.view addSubview:FileTable];
    
}




#pragma mark table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==FolderTable){
        return FolderDatasource.count;
    }
    else{
        return FileDatasource.count;
    }
    
}


// 创建 tableView 的 cell
- ( UITableViewCell *)tableView:( UITableView *)tableView cellForRowAtIndexPath:( NSIndexPath *)indexPath
{
    if(tableView==FolderTable)
    {
        FolderTableCell *cell=[FolderTableCell cellWithTableView:tableView];
        FolderModel* TempModel=[FolderDatasource objectAtIndex:indexPath.row];
        [cell.FoldNameLabel setText:TempModel.stageModuleName];
        [cell.FoldNumberLabel setText:TempModel.num];
        return cell;
    }else{
        FileTableCell *cell=[FileTableCell cellWithTableView:tableView];
        FileModel* TempModel=[FileDatasource objectAtIndex:indexPath.row];
        
        [cell.FileNameLabel setText:TempModel.fileName];
        [cell.FilePeopleName setText:TempModel.createUserName];
        [cell.DateLabel setText:TempModel.createTime];
        
        if([TempModel.fileType isEqualToString:@"7"])
        {
            [cell.FileImageView setImage:[UIImage imageNamed:@"jpg@3x.png"]];
        }
        if([TempModel.fileType isEqualToString:@"11"]){
            [cell.FileImageView setImage:[UIImage imageNamed:@"doc@3x.png"]];
        }
        if([TempModel.fileType isEqualToString:@"12"]){
            [cell.FileImageView setImage:[UIImage imageNamed:@"xls@3x.png"]];
        }
        if([TempModel.fileType isEqualToString:@"13"]){
            [cell.FileImageView setImage:[UIImage imageNamed:@"ppt@3x.png"]];
        }
        if([TempModel.fileType isEqualToString:@"14"]){
            [cell.FileImageView setImage:[UIImage imageNamed:@"pdf@3x.png"]];
        }
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==FolderTable)
    {
        //发起小页面请求
        FolderModel* TempModel=[FolderDatasource objectAtIndex:indexPath.row];
        [self GetFileDataWithFolderName:TempModel.stageModuleName];
    }else
    {
        //打开新的url
        FileModel* model=[FileDatasource objectAtIndex:indexPath.row];
        NSLog(@"%@",model.fileUrl);
    }
}

#pragma mark 点击事件
- (void)ChangeListModel{
    
    if(IfisFolder==YES)
    {
        //发起文件请求--在请求获得结果以后设置ifisfolder为no
        [self GetFileDataWithFolderName:@"all"];
        //        IfisFolder=NO;
    }else
    {
        //显示文件夹--设置ifisfolder为yes
        [ChangeButton setTitle:@"显示全部文件" forState:UIControlStateNormal];
        IfisFolder=YES;
        FolderTable.hidden=NO;
        FileTable.hidden=YES;
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
