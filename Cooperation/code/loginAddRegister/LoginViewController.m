//
//  LoginViewController.m
//  synergy
//
//  Created by Tion on 17/1/12.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "PJTabBarController.h"
#import "TabBarController.h"
#import "HttpSessionManager.h"
#import "BaseInfomationViewController.h"
#import "NSDictionary+LJAdditions.h"


E_ROLE role;

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController
{
//    BOOL autoLogin;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    [self ChangeViewStyles];
    
    [self SetFunction];
    
    [self AddKeyboardGesture];
    
    //添加键盘变更通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ChangeViewStyles{
    //倒角设置
    [self SetBorderRadius];
    
    //控件背景
    [self SetBackGround];
    
//    placeholder设置,textstyle设置
    [self SetPlaceholder];
    
//    控件字体颜色
    [self SetFontColor];
    
    //尝试自动登录
    [self TryAutoLogin];
    
}

- (void)SetBorderRadius{
    
    _SecondView.layer.masksToBounds=YES;
    _SecondView.layer.cornerRadius=6.0;
    
    _ThirdView.layer.masksToBounds=YES;
    _ThirdView.layer.cornerRadius=6.0;
    
    _FourthView.layer.masksToBounds=YES;
    _FourthView.layer.cornerRadius=6.0;
    
    _AutoLoginImageView.layer.masksToBounds=YES;
    _AutoLoginImageView.layer.cornerRadius=15.0;

}

- (void)SetBackGround{
    [_FourthView setBackgroundColor:[UIColor colorWithHexString:@"#36CF95"]];
    
    [_BottomView setBackgroundColor:[UIColor clearColor]];
    
    //设定图片时要根据状态选择
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    if([UserDefaults objectForKey:@"autoLogin"])
    {
        NSString* autoLogin=[UserDefaults objectForKey:@"autoLogin"];
        if([autoLogin isEqualToString:@"autoLogin"])
        {
            [_AutoLoginImageView setBackgroundImage:[UIImage imageNamed:@"selected@3x.png"] forState:UIControlStateNormal];
        }
        else{
            [_AutoLoginImageView setBackgroundImage:[UIImage imageNamed:@"unselected@3x.png"] forState:UIControlStateNormal];
        }
        
    }
    else{
        //直接设定为不自动登录
        [_AutoLoginImageView setBackgroundImage:[UIImage imageNamed:@"unselected@3x.png"] forState:UIControlStateNormal];
    }
    //点击事件
    _AutoLoginImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChangeAutoLogin)];
    [_AutoLoginImageView addGestureRecognizer:singleTap1];

    
    
    
    [_AutoLoginImageView setBackgroundColor:[UIColor clearColor]];
}

- (void)SetPlaceholder{
    [_UserNameTextField setPlaceholder:@"手机号"];
    _UserNameTextField.borderStyle=UITextBorderStyleNone;
    _UserNameTextField.delegate=self;
    
    [_PasswordTextField setPlaceholder:@"密码"];
    [_PasswordTextField setSecureTextEntry:YES];
    _PasswordTextField.borderStyle=UITextBorderStyleNone;
    _PasswordTextField.delegate=self;
}

- (void)SetFontColor{
    [_LoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_AutoLoginTipView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)SetFunction{
    [_LoginButton addTarget:self action:@selector(LoginCheck) forControlEvents:UIControlEventTouchUpInside];
}



#pragma mark 登陆网络接口
- (void)LoginCheck{
    //检验登陆是否可用
    NSString* user=_UserNameTextField.text;
    NSString* password=_PasswordTextField.text;
    if([user isEqualToString:@""] || [password isEqualToString:@""])
    {
        UIAlertController* AlertToShow=[UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* confirm){
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [AlertToShow addAction:confirm];
        [self presentViewController:AlertToShow animated:NO completion:^{}];
    }else{
        [self LoginWithUserName:user AndPassword:password];
    }
  
    
}


- (void)LoginWithUserName:(NSString*)user AndPassword:(NSString*)password{
    NSDictionary* dicPara = @{@"loginName":user, @"passWord":password};
    
    [HTTP_MANAGER startNormalPostWithParagram:dicPara Commandtype:@"app/check" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        if (isSucceed) {
            
            
            //存储用户信息
            NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
            [UserDefaults setObject:user forKey:@"user"];
            [UserDefaults setObject:password forKey:@"password"];
            
            NSString* userId = [succeedResult lj_stringForKey:@"userId"];
            [UserDefaults setObject:userId forKey:@"userId"];
            [UserDefaults synchronize];
            
            //进入首页
            PJTabBarController* vc=[[PJTabBarController alloc]init];
            //BaseInfomationViewController* vc = [[BaseInfomationViewController alloc]initWithProjectId:@"" ProjectName:@"" type:E_INFO_EDIT];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
        else{
            [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:2];
        }
    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
        [PubllicMaskViewHelper showTipViewWith:@"请求失败，请检查网络设置后重试" inSuperView:self.view withDuration:2];
    }];
}

#pragma mark 点击事件
- (void)TryAutoLogin{
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    if([UserDefaults objectForKey:@"autoLogin"])
    {
        NSString* autoLogin=[UserDefaults objectForKey:@"autoLogin"];
        if([autoLogin isEqualToString:@"autoLogin"])
        {
            //自动登录
            if([UserDefaults objectForKey:@"user"]&&[UserDefaults objectForKey:@"password"])
            {
                NSString* user=[UserDefaults objectForKey:@"user"];
                NSString* password=[UserDefaults objectForKey:@"password"];
                //设定
                [_UserNameTextField setText:user];
                [_PasswordTextField setText:password];
                [self LoginWithUserName:user AndPassword:password];
            }
            else if ([UserDefaults objectForKey:@"user"] && ![UserDefaults objectForKey:@"password"]){
                //注销的操作
                NSString* user=[UserDefaults objectForKey:@"user"];
                [_UserNameTextField setText:user];
//                [_PasswordTextField setText:password];
            }
            else{
                //尚未正常登录过
            }
        }
        else{
            //未选择自动登录
            if([UserDefaults objectForKey:@"user"]&&[UserDefaults objectForKey:@"password"])
            {
                NSString* user=[UserDefaults objectForKey:@"user"];
                [_UserNameTextField setText:user];
            }
            else{
                //尚未正常登录过
            }
        }
    }
    else{
        //无自动登录偏好设置
        //设定自动登录并修改图片
        [self ChangeAutoLogin];
        
    }
}

- (void)ChangeAutoLogin{
    //先改偏好，再根据偏好改变图片
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    if([UserDefaults objectForKey:@"autoLogin"])
    {
        NSString* autoLogin=[UserDefaults objectForKey:@"autoLogin"];
        if([autoLogin isEqualToString:@"autoLogin"])
        {
            [UserDefaults setObject:@"unLogin" forKey:@"autoLogin"];
            [_AutoLoginImageView setBackgroundImage:[UIImage imageNamed:@"unselected@3x.png"] forState:UIControlStateNormal];
        }
        else{
            [UserDefaults setObject:@"autoLogin" forKey:@"autoLogin"];
            [_AutoLoginImageView setBackgroundImage:[UIImage imageNamed:@"selected@3x.png"] forState:UIControlStateNormal];
        }
        
    }
    else{
        [UserDefaults setObject:@"autoLogin" forKey:@"autoLogin"];
        //直接设定为不自动登录
        [_AutoLoginImageView setBackgroundImage:[UIImage imageNamed:@"selected@3x.png"] forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
}

#pragma mark 添加手势收起键盘
- (void)AddKeyboardGesture{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = YES;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UISwipeGestureRecognizer* swipeGestureRecognizer= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardHide:)];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
}

#pragma mark 键盘监听
-(void)KeyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    //获取高度
    NSValue  *my=[info objectForKey:@"UIKeyboardFrameBeginUserInfoKey"];
    NSLog(@"size=%f",[my CGRectValue].size.height);
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];//关键的一句，网上关于获取键盘高度的解决办法，多到这句就over了。系统宏定义的UIKeyboardBoundsUserInfoKey等测试都不能获取正确的值。不知道为什么。。。
    
    CGSize keyboardSize = [value CGRectValue].size;
//    NSLog(@"横屏%f",keyboardSize.height);
    float keyboardHeight = keyboardSize.height;
    NSLog(@"%lf,%lf",keyboardHeight,MAIN_HEIGHT);
    // 获取键盘弹出的时间
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    //自定义的frame大小的改变的语句
    //顶到登陆下
    CGFloat Height=MAIN_HEIGHT/6;
    [self.view setFrame:CGRectMake(0, -keyboardHeight+Height,MAIN_WIDTH, MAIN_HEIGHT)];
}

-(void)KeyboardWillHidden:(NSNotification *)notification
{
    //回复frame大小
    [self.view setFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT)];
}

- (void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_UserNameTextField resignFirstResponder];
    [_PasswordTextField resignFirstResponder];
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
