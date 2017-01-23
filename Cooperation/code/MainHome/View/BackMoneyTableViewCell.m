//
//  BackMoneyTableViewCell.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "BackMoneyTableViewCell.h"
#import "ProjectDetailModel.h"

@interface BackMoneyTableViewCell()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField* date;
@property(nonatomic,strong)UITextField* money;
@end

@implementation BackMoneyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _date = [[UITextField alloc]initWithFrame:CGRectMake(15, -1, (MAIN_WIDTH-30)/2, 44)];
        [_date setFont:[UIFont systemFontOfSize:14]];
        [_date setTextAlignment:NSTextAlignmentCenter];
        [_date setTextColor:[UIColor colorWithHexString:@"#F1F1F1"]];
        _date.delegate = self;
        [_date setBackgroundColor:[UIColor whiteColor]];
        _date.layer.borderColor = [UIColor colorWithHexString:@"#F1F1F1"].CGColor;
        _date.layer.borderWidth = 0.5;
        _date.layer.masksToBounds = YES;
        [self.contentView addSubview:_date];
        _money =[[UITextField alloc]initWithFrame:CGRectMake(15, (MAIN_WIDTH-30)/2, (MAIN_WIDTH-30)/2, 44)];
        [_money setFont:[UIFont systemFontOfSize:14]];
        [_money setTextAlignment:NSTextAlignmentCenter];
        _money.delegate = self;
        _money.layer.borderColor = [UIColor colorWithHexString:@"#F1F1F1"].CGColor;
        _money.layer.borderWidth = 0.5;
        _money.layer.masksToBounds = YES;
        [_money setTextColor:[UIColor colorWithHexString:@"#F1F1F1"]];
        [self.contentView addSubview:_money];
    }
    return self;
}

-(void)setIsTableHeader:(BOOL)isTableHeader{
    if (isTableHeader) {
        [_date setBackgroundColor:[UIColor colorWithHexString:@"#F1F1F1"]];
        [_date setTextColor:COMMON_CORLOR_HIGHLIGHT];
        
        [_money setBackgroundColor:[UIColor colorWithHexString:@"#F1F1F1"]];
        [_money setTextColor:COMMON_CORLOR_HIGHLIGHT];
    }
}

-(void)setModel:(CreditModel *)model{
    _model = model;
    _date.text = model.name;
    _money.text = model.projectContentValue;
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_model.edit) {
        return YES;
    }
    else{
        return NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString* str=textField.text;
    NSString* name=self.model.name;
    [self.delegate BankMoneyPassValue:[NSString stringWithFormat:@"bank---%@--%@",str,name]];
}

@end
