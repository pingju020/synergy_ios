//
//  MineMainViewController.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/20.
//  Copyright © 2017年 yangjuanping. All rights reserved.
//

#import "MineMainViewController.h"
#import "PJTabBarItem.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+LJAdditions.h"
#import "AboutViewController.h"
@interface MineMainViewController ()

@end

@implementation MineMainViewController
{
    CGSize MyViewSize;
    CGFloat MyViewStart;
    CGFloat MarginLeft;//right同
    
    UIView* ImageBackground;
    UIImageView* IconView;
    
    UIView* MessageBackground;
    UILabel* Name;
    UILabel* Address;
    UILabel* Department;
    
    UIView* ExitBackground;
    UIButton* PhoneNumber;
    UIButton* ExitButton;
    UIView* viewRedPoint;
}
AH_BASESUBVCFORMAINTAB_MODULE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self SetViews];
    
    [self GetData];
    
    [self SetExitFunction];
    
    backBtn.hidden=YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(PJTabBarItem*)getTabBarItem{
    //
    PJTabBarItem* itemMainHome = [[PJTabBarItem alloc]init];
    itemMainHome.strTitle = @"我的";
    itemMainHome.strNormalImg = @"mine@2x.png";
    itemMainHome.strSelectImg = @"mine_press@2x.png";
    itemMainHome.viewController = self;
    itemMainHome.tabIndex = 5;
    //title.text = itemMainHome.strTitle;
    [self setTitle:itemMainHome.strTitle];
    return itemMainHome;
}




#pragma mark 主体流程
/* step1.页面设置 */
- (void)SetViews{
    /* 等分为3部分--1.图片2.信息3.注销 */
    //设定自身尺寸
    [self SetFrameAndSize];
    //图片
    [self SetImageRound];
    //信息
    [self SetMessageRound];
    //注销
    [self SetExitRound];
}


/* 定制尺寸等参数 */
- (void)SetFrameAndSize{
    //基本尺寸
    CGRect BaseRect=self.view.frame;
    CGSize BaseSize=BaseRect.size;
    
    CGRect StatusFrame=[[UIApplication sharedApplication]statusBarFrame];
    CGFloat StatusHeight=StatusFrame.size.height;
    
    CGFloat NavigatorHeight=44;
    CGFloat TabbarHeight=49;
    
    MyViewSize=CGSizeMake(BaseSize.width, BaseSize.height-StatusHeight-TabbarHeight-NavigatorHeight);
    MyViewStart=StatusHeight+NavigatorHeight;//0;
    MarginLeft=20.0;
}

#pragma mark 归属于view设定
/* 图片区域设定 */
- (void)SetImageRound{
    ImageBackground=[[UIView alloc]initWithFrame:CGRectMake(0, MyViewStart, MyViewSize.width, MyViewSize.height/3)];
    [ImageBackground setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:ImageBackground];
    //设定图片未100*100大小
    IconView=[[UIImageView alloc]initWithFrame:CGRectMake(MyViewSize.width/2-60, MyViewSize.height/6-60, 120, 120)];
    IconView.layer.masksToBounds=YES;
    IconView.layer.cornerRadius=60.0;
    IconView.image=[UIImage imageNamed:@"icon@3x.png"];
    
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MeJumpPicker)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer2.cancelsTouchesInView = YES;
    IconView.userInteractionEnabled = YES;
    //将触摸事件添加到当前view
    [IconView addGestureRecognizer:tapGestureRecognizer2];
    
    [ImageBackground addSubview:IconView];
}

/* 信息区域设定 */
- (void)SetMessageRound{
    MessageBackground=[[UIView alloc]initWithFrame:CGRectMake(0, MyViewStart+MyViewSize.height/3, MyViewSize.width, MyViewSize.height/3)];
    [MessageBackground setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:MessageBackground];
    //亮痕
    UIView* LineView=[[UIView alloc]initWithFrame:CGRectMake(0,0,MyViewSize.width,1)];
    [LineView setBackgroundColor:[UIColor colorWithHexString:@"#E0E5F6"]];
    [MessageBackground addSubview:LineView];
    //buff条
    UIView* BlankView=[[UIView alloc]initWithFrame:CGRectMake(0,1,MyViewSize.width,19)];
    [BlankView setBackgroundColor:[UIColor colorWithHexString:@"#F7F9FD"]];
    [MessageBackground addSubview:BlankView];
    
    CGFloat MessageBarHeight=(MyViewSize.height/3-20-3)/3;
    
    //姓名
    UIView* MessageName=[[UIView alloc]initWithFrame:CGRectMake(0, 20, MyViewSize.width, MessageBarHeight)];
    [MessageBackground addSubview:MessageName];
    
    UILabel* NameTip=[[UILabel alloc]initWithFrame:CGRectMake(MarginLeft, 0, 100, MessageBarHeight)];
    [NameTip setText:@"姓名"];
    [NameTip setTextAlignment:NSTextAlignmentLeft];
    [NameTip setTextColor:[UIColor colorWithHexString:@"#9A9A9A"]];
    [MessageName addSubview:NameTip];
    Name=[[UILabel alloc]initWithFrame:CGRectMake(MyViewSize.width-MarginLeft-300,0, 300, MessageBarHeight)];
    //    [Name setText:@"sarris"];
    [Name setTextAlignment:NSTextAlignmentRight];
    [Name setTextColor:[UIColor colorWithHexString:@"#36C8F4"]];
    [MessageName addSubview:Name];
    UIView* Line1=[[UIView alloc]initWithFrame:CGRectMake(0, 20+MessageBarHeight, MyViewSize.width, 1)];
    [Line1 setBackgroundColor:[UIColor colorWithHexString:@"#E4E4E4"]];
    [MessageBackground addSubview:Line1];
    
    //办公地点
    UIView* MessageAddress=[[UIView alloc]initWithFrame:CGRectMake(0, 20+MessageBarHeight+1, MyViewSize.width, MessageBarHeight)];
    [MessageBackground addSubview:MessageAddress];
    
    UILabel* AddressTip=[[UILabel alloc]initWithFrame:CGRectMake(MarginLeft, 0, 100, MessageBarHeight)];
    [AddressTip setText:@"部门"];
    [AddressTip setTextAlignment:NSTextAlignmentLeft];
    [AddressTip setTextColor:[UIColor colorWithHexString:@"#9A9A9A"]];
    [MessageAddress addSubview:AddressTip];
    Address=[[UILabel alloc]initWithFrame:CGRectMake(MyViewSize.width-MarginLeft-300,0, 300, MessageBarHeight)];
    [Address setTextColor:[UIColor colorWithHexString:@"#36C8F4"]];
    [Address setTextAlignment:NSTextAlignmentRight];
    [MessageAddress addSubview:Address];
    UIView* Line2=[[UIView alloc]initWithFrame:CGRectMake(0, 20+2*MessageBarHeight+1, MyViewSize.width, 1)];
    [Line2 setBackgroundColor:[UIColor colorWithHexString:@"#E4E4E4"]];
    [MessageBackground addSubview:Line2];
    
    //部门
    UIView* MessageDepartment=[[UIView alloc]initWithFrame:CGRectMake(0, 20+2*MessageBarHeight+2, MyViewSize.width, MessageBarHeight)];
    [MessageBackground addSubview:MessageDepartment];
    
    UILabel* DepartmentTip=[[UILabel alloc]initWithFrame:CGRectMake(MarginLeft, 0, 100, MessageBarHeight)];
    [DepartmentTip setText:@"手机号码"];
    [DepartmentTip setTextAlignment:NSTextAlignmentLeft];
    [DepartmentTip setTextColor:[UIColor colorWithHexString:@"#9A9A9A"]];
    [MessageDepartment addSubview:DepartmentTip];
    Department=[[UILabel alloc]initWithFrame:CGRectMake(MyViewSize.width-MarginLeft-300,0, 300, MessageBarHeight)];
    [Department setTextColor:[UIColor colorWithHexString:@"#36C8F4"]];
    [Department setTextAlignment:NSTextAlignmentRight];
    [MessageDepartment addSubview:Department];
    UIView* Line3=[[UIView alloc]initWithFrame:CGRectMake(0, 20+3*MessageBarHeight+2, MyViewSize.width, 1)];
    [Line3 setBackgroundColor:[UIColor colorWithHexString:@"#E4E4E4"]];
    [MessageBackground addSubview:Line3];
}

/* 注销区域设定 */
- (void)SetExitRound{
    ExitBackground=[[UIView alloc]initWithFrame:CGRectMake(0, MyViewStart+MyViewSize.height*2/3, MyViewSize.width, MyViewSize.height/3)];
    [ExitBackground setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
    [self.view addSubview:ExitBackground];
    
    //电话
    CGFloat MessageBarHeight=(MyViewSize.height/3-20-3)/3;
    UIView* MessagePhone=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MyViewSize.width, MessageBarHeight)];
    [MessagePhone setBackgroundColor:[UIColor whiteColor]];
    [ExitBackground addSubview:MessagePhone];
    
    UILabel* PhoneTip=[[UILabel alloc]initWithFrame:CGRectMake(MarginLeft, 0, 100, MessageBarHeight)];
    [PhoneTip setText:@"关于"];
    [PhoneTip setTextAlignment:NSTextAlignmentLeft];
    [PhoneTip setTextColor:[UIColor colorWithHexString:@"#9A9A9A"]];
    [MessagePhone addSubview:PhoneTip];
    PhoneNumber=[[UIButton alloc]initWithFrame:CGRectMake(MyViewSize.width-MarginLeft-20,0, 20, MessageBarHeight)];
    [PhoneNumber setImage:[UIImage imageNamed:@"右箭头@2x.png"] forState:UIControlStateNormal];
    //    [PhoneNumber setText:@"188888888"];
//    [PhoneNumber setTextAlignment:NSTextAlignmentRight];
    
    viewRedPoint = [[UIView alloc]initWithFrame:(CGRect){0,0,10,10}];
    viewRedPoint.backgroundColor = [UIColor redColor];
    viewRedPoint.layer.cornerRadius = 5;
    viewRedPoint.layer.masksToBounds = YES;
    [MessagePhone addSubview:viewRedPoint];
    viewRedPoint.lj_centerY = MessagePhone.lj_centerY;
    viewRedPoint.lj_right = PhoneNumber.lj_left;
    
    UITapGestureRecognizer *tapAbout = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAbout)];
    tapAbout.cancelsTouchesInView = YES;
    MessagePhone.userInteractionEnabled = YES;
    [MessagePhone addGestureRecognizer:tapAbout];
    
    [MessagePhone addSubview:PhoneNumber];
    //退出
    CGFloat ExitBarHeight=MyViewSize.height/12;
    
    ExitButton=[[UIButton alloc]initWithFrame:CGRectMake(MarginLeft,MyViewSize.height/3-2*ExitBarHeight, MyViewSize.width-2*MarginLeft, ExitBarHeight)];
    [ExitButton setTitle:@"注    销" forState:UIControlStateNormal];
    [ExitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ExitButton.layer.masksToBounds=YES;
    ExitButton.layer.cornerRadius=ExitBarHeight/2;
//    ExitButton.layer.borderColor=[[UIColor colorWithHexString:@"#A2B0DF"]CGColor];
//    ExitButton.layer.borderWidth=1.0;
    ExitButton.backgroundColor=[UIColor colorWithHexString:@"#3983CA"];
    [ExitBackground addSubview:ExitButton];
}

- (void)onAbout{
    AboutViewController* vc = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 获取数据
- (void)GetData{
    //登录
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         @"multipart/form-data",
                                                         @"text/plain",
                                                         nil];
    NSString *url=[NSString stringWithFormat:@"%@app/getUser",HOST_ADDRESS];
    NSMutableDictionary* dic=[NSMutableDictionary new];
    
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* TempString=[UserDefaults objectForKey:@"user"];
    
    [dic setObject:TempString forKey:@"phone"];
    
    NSURLSessionDataTask *task = [manager POST:url
                                    parameters:dic
                                      progress:^(NSProgress * _Nonnull uploadProgress) {
                                          //打印下上传进度
                                          NSLog(@"上传进度");
                                          NSLog(@"%@",uploadProgress);
                                      }
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           //上传成功
                                           NSLog(@"上传成功");
                                           NSLog(@"%@",responseObject);
                                           
                                           NSDictionary* DataDic=[responseObject objectForKey:@"data"];
                                           
                                           NSString* mobile=[DataDic objectForKey:@"phone"];
                                           
                                           NSString* nametrans=[DataDic objectForKey:@"name"];
                                           NSString* name=[Tools replaceUnicode:nametrans];
                                           
                                           NSString* officeName=[DataDic objectForKey:@"officeName"];
                                           NSString* department=[Tools replaceUnicode:officeName];
                                           
                                    
                                           
                                           [Name setText:name];
                                           [Department setText:mobile];
                                           [Address setText:officeName];
                                           
                                         
                                           
                                           NSString* photoString=[DataDic objectForKey:@"photo"];
                                           if([photoString isEqualToString:@""]){
                                               
                                           }else{
                                               NSURL* url=[NSURL URLWithString:photoString];
                                               [ IconView sd_setImageWithURL:url];
                                           }
                                       }
                                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           //上传失败
                                           NSLog(@"%@",error);
                                           NSLog(@"上传失败");
                                       }];
}

#pragma mark 注销方法
- (void)SetExitFunction{
    [ExitButton addTarget:self action:@selector(ExitApplication) forControlEvents:UIControlEventTouchUpInside];
}

- (void)ExitApplication{
    //更改自动登录状态
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    //    [UserDefaults setObject:@"unLogin" forKey:@"autoLogin"];
    [UserDefaults setObject:nil forKey:@"password"];
    //退出APP(返回登录)
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController=[[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
}
#pragma mark 可调用方法类
- (void)goback{
    if(1)
    {
        
    }
    else{
        //        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (BOOL)navigationShouldPopOnBackButton{
    
    
    NSLog(@"lailailai");
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}

- (void)backAction{
    //donothing
}

#pragma mark 图片选择
//跳转picker页面
-(void)MeJumpPicker{
    //初始化类
    UIImagePickerController* picker_library_ = [[UIImagePickerController alloc] init];
    //指定几总图片来源
    //UIImagePickerControllerSourceTypePhotoLibrary：表示显示所有的照片。
    //UIImagePickerControllerSourceTypeCamera：表示从摄像头选取照片。
    //UIImagePickerControllerSourceTypeSavedPhotosAlbum：表示仅仅从相册中选取照片。
    picker_library_.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //表示用户可编辑图片。
    picker_library_.allowsEditing = YES;
    //代理
    picker_library_.delegate = self;
    [self presentViewController:picker_library_ animated:NO completion:^{}];
}

//获取图片
- (void)imagePickerController: (UIImagePickerController *)picker
didFinishPickingMediaWithInfo: (NSDictionary *)info
{
    //获得编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    
    [self dismissModalViewControllerAnimated:YES];
    [self postHisImage:image];
}



-(void)postHisImage:(UIImage*)image{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         @"multipart/form-data",
                                                         nil];
    
    NSString *url=[NSString stringWithFormat:@"%@uploadfile/upload",HOST_ADDRESS];
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSData *imageDatas =UIImageJPEGRepresentation(image, 0.1) ;
    [dic setValue:@"13621580762" forKey:@"phone"];
    
    
    
    NSURLSessionDataTask *task = [manager POST:url
                                    parameters:nil
                     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
                                  {
                                      NSData *imageDatas =UIImageJPEGRepresentation(image, 0.1) ;
                                      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                      formatter.dateFormat = @"yyyyMMddHHmmss";
                                      NSString *str = [formatter stringFromDate:[NSDate date]];
                                      NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                                      //上传的参数(上传图片，以文件流的格式)
                                      [formData appendPartWithFileData:imageDatas
                                                                  name:@"file"
                                                              fileName:fileName
                                                              mimeType:@"image/jpeg"];
                                  }
                                      progress:^(NSProgress * _Nonnull uploadProgress) {
                                          //打印下上传进度
                                          NSLog(@"上传进度");
                                          NSLog(@"%@",uploadProgress);
                                      }
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           //上传成功
                                           NSLog(@"上传成功");
                                           NSLog(@"aaaaaa=reps=%@",responseObject);
                                           NSString* imageUrl=[responseObject objectForKey:@"data"];
                                           
                                           [self PostImageUrl:imageUrl];
                                       }
                                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           //上传失败
                                           NSLog(@"上传失败");
                                           NSLog(@"%@",error);
                                       }];
}


#pragma mark 上传图片路径
- (void)PostImageUrl:(NSString*)ImageUrl{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         @"multipart/form-data",
                                                         @"text/plain",
                                                         nil];
    
    NSString *url=[NSString stringWithFormat:@"%@app/updateImg",HOST_ADDRESS];
    NSMutableDictionary* dic=[NSMutableDictionary new];
    
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* TempString=[UserDefaults objectForKey:@"user"];
    
    [dic setObject:TempString forKey:@"phone"];
    [dic setValue:ImageUrl forKey:@"imgUrl"];
    NSURLSessionDataTask *task = [manager POST:url
                                    parameters:dic
                                      progress:^(NSProgress * _Nonnull uploadProgress) {
                                          //打印下上传进度
                                          NSLog(@"上传进度");
                                          NSLog(@"%@",uploadProgress);
                                      }
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           //上传成功
                                           NSLog(@"上传成功");
                                           NSLog(@"%@",responseObject);
                                           
                                           NSString* imageUrl=[responseObject objectForKey:@"msg"];
                                           NSLog(@"%@",[Tools replaceUnicode:imageUrl]);
                                           
                                           //如果返回成功则重新获取整个信息
                                           [self GetData];
                                           
                                           
                                       }
                                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           //上传失败
                                           NSLog(@"%@",error);
                                           NSLog(@"上传失败");
                                       }];
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
