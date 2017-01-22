//
//  ProjectNewViewController.m
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectNewViewController.h"
#import "SelectOperatorViewController.h"
#import "HttpSessionManager.h"
@interface ProjectNewViewController ()<ChoosePeopleDelegate>

@end

@implementation ProjectNewViewController
{
    UITextField* ProjectNameTextField;
    UITextField* ProjectManagerNameTextField;
    
    NSString* paramsID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self ResetNavigationBG];
    
    [self SetInput];
    
    [self SetConfirmButton];
}

- (void)ResetNavigationBG{
    self.title=@"新增项目";
    [backBtn setImage:[UIImage imageNamed:@"back@3x.png"] forState:UIControlStateNormal];
    
}

#pragma mark 输入区域--项目名/项目负责人
- (void)SetInput{
    [self SetProjectManagerInput];
    [self SetProjectNameInput];
}

- (void)SetProjectNameInput{
    UIView* NameBackView=[[UIView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT, SCREEN_WIDTH, 80)];
    [self.view addSubview:NameBackView];
    
    UILabel* ProjectNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,0,SCREEN_WIDTH/4,80)];
    [ProjectNameLabel setTextColor:[UIColor darkGrayColor]];
    [ProjectNameLabel setText:@"项目名称"];
    [NameBackView addSubview:ProjectNameLabel];
    
    ProjectNameTextField=[[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-SCREEN_WIDTH/2,0,SCREEN_WIDTH/2,80)];
    [ProjectNameTextField setPlaceholder:@"请填写项目名称"];
    [ProjectNameTextField setTextAlignment:NSTextAlignmentRight];
    [NameBackView addSubview:ProjectNameTextField];
    
    UIView* LineView=[[UIView alloc]initWithFrame:CGRectMake(0,79,SCREEN_WIDTH,1)];
    [LineView setBackgroundColor:[UIColor colorWithHexString:@"#F7F7F7"]];
    [NameBackView addSubview:LineView];
}

- (void)SetProjectManagerInput{
    UIView* PeopleNameBackView=[[UIView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT+80, SCREEN_WIDTH, 80)];
    [self.view addSubview:PeopleNameBackView];
    
    UILabel* ProjectManagerNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,0,SCREEN_WIDTH/4,80)];
    [ProjectManagerNameLabel setTextColor:[UIColor darkGrayColor]];
    [ProjectManagerNameLabel setText:@"项目负责人"];
    [PeopleNameBackView addSubview:ProjectManagerNameLabel];
    
    UIButton* AddButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [AddButton setFrame:CGRectMake(SCREEN_WIDTH-20-31,19, 56-5-20, 46-5)];
    [AddButton setImageEdgeInsets:UIEdgeInsetsMake(10,10, 10, 0)];
    [AddButton setBackgroundColor:[UIColor clearColor]];
    [AddButton setImage:[UIImage imageNamed:@"addManager@3x.png"] forState:UIControlStateNormal];
    [AddButton addTarget:self action:@selector(SelectProjectMangaer) forControlEvents:UIControlEventTouchUpInside];
    [PeopleNameBackView addSubview:AddButton];
    
    
    ProjectManagerNameTextField=[[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-SCREEN_WIDTH/2-21-10,0,SCREEN_WIDTH/2,80)];
    [ProjectManagerNameTextField setPlaceholder:@"请选择负责人"];
    [ProjectManagerNameTextField setTextAlignment:NSTextAlignmentRight];
    [ProjectManagerNameTextField setEnabled:NO];
    [PeopleNameBackView addSubview:ProjectManagerNameTextField];
    
    UIView* LineView=[[UIView alloc]initWithFrame:CGRectMake(0,79,SCREEN_WIDTH,1)];
    [LineView setBackgroundColor:[UIColor colorWithHexString:@"#F7F7F7"]];
    [PeopleNameBackView addSubview:LineView];
}

- (void)SetConfirmButton
{
    UIButton* ConfirmButton=[[UIButton alloc]initWithFrame:CGRectMake(20,SCREEN_HEIGHT/2-60,SCREEN_WIDTH-40,60)];
    [ConfirmButton setBackgroundColor:[UIColor colorWithHexString:@"#3B7EC6"]];
    [ConfirmButton setTitle:@"保     存" forState:UIControlStateNormal];
    ConfirmButton.layer.masksToBounds=YES;
    ConfirmButton.layer.cornerRadius=30;
    [ConfirmButton addTarget:self action:@selector(AddNewProject) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ConfirmButton];
}

- (void)SelectProjectMangaer
{
    SelectOperatorViewController* view=[[SelectOperatorViewController alloc]initWithSelectType:@"manager"];
    view.delegate=self;
    [self.navigationController pushViewController:view animated:NO];
}

- (void)chooseOperatorOrManagerWithName:(NSString *)name AndId:(NSString *)peopleid{
    [ProjectManagerNameTextField setText:name];
    paramsID=peopleid;
    
//    NSLog(@"name=%@,id=%@",name,peopleid);
}

#pragma mark 点击事件
- (void)AddNewProject{
    if(ProjectNameTextField.text && ProjectManagerNameTextField.text && paramsID){
        
        NSMutableDictionary* dic=[NSMutableDictionary new];
        NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
        NSString* TempString=[UserDefaults objectForKey:@"user"];
        
        [dic setObject:TempString forKey:@"phone"];
        [dic setObject:ProjectNameTextField.text forKey:@"projectName"];
        [dic setObject:paramsID forKey:@"userId"];
        
        [HTTP_MANAGER startNormalPostWithParagram:dic Commandtype:@"app/project/getProjectData" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
            if (isSucceed) {
                NSLog(@"-------%@-----",succeedResult);
            
            }
            else{
                [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:2];
            }
        } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
            [PubllicMaskViewHelper showTipViewWith:@"请求失败，请检查网络设置后重试" inSuperView:self.view withDuration:2];
        }];
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
