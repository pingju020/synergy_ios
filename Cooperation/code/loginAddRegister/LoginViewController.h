//
//  LoginViewController.h
//  synergy
//
//  Created by Tion on 17/1/12.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController



@property (weak, nonatomic) IBOutlet UIView *SecondView;
@property (weak, nonatomic) IBOutlet UITextField *UserNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *UserNameImageView;




@property (weak, nonatomic) IBOutlet UIView *ThirdView;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *PasswordImageView;



@property (weak, nonatomic) IBOutlet UIView *FourthView;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;

@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (weak, nonatomic) IBOutlet UIView *BottomContainerView;
@property (weak, nonatomic) IBOutlet UIButton *AutoLoginImageView;
@property (weak, nonatomic) IBOutlet UIButton *AutoLoginTipView;


@end
