//
//  NumberTypeTableViewCell.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "NumberTypeTableViewCell.h"
#import "ProjectDetailModel.h"

@interface NumberTypeTableViewCell()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField* input;
@property(nonatomic,strong)UILabel* money;
@property(nonatomic,strong)UIView* sep;
@end

@implementation NumberTypeTableViewCell

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
        
        [self.textLabel setFont:[UIFont systemFontOfSize:14]];
        [self.textLabel setTextColor:[UIColor darkGrayColor]];
        [self.textLabel setTextAlignment:NSTextAlignmentLeft];
        [self.textLabel setWidth:60];
        self.textLabel.numberOfLines = 0;
        
        _input = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.textLabel.frame)+10, 0, MAIN_WIDTH - CGRectGetMaxX(self.textLabel.frame)-10-45, 56)];
        [_input setTextAlignment:NSTextAlignmentRight];
        [_input setTextColor:COMMON_CORLOR_HIGHLIGHT];
        [_input setFont:[UIFont systemFontOfSize:14]];
        _input.delegate=self;
        [self.contentView addSubview:_input];
        
        _money = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_input.frame)+5, 0, 40, 56)];
        [_money setFont:[UIFont systemFontOfSize:14]];
        [_money setBackgroundColor:[UIColor colorWithHexString:@"F1F1F1"]];
        [_money setTextColor:[UIColor darkGrayColor]];
        [_money setTextAlignment:NSTextAlignmentCenter];
        [_money setText:@"万元"];
        [self.contentView addSubview:_money];
        
        _sep = [[UIView alloc]initWithFrame:CGRectMake(0, 55, MAIN_WIDTH, 1)];
        [_sep setBackgroundColor:VcBackgroudColor];
        [self.contentView addSubview:_sep];
    }
    return self;
}

-(void)setModel:(FactorModel *)model{
    _model = model;
    [self.self.textLabel setText:model.name];
    [self.input setPlaceholder:[NSString stringWithFormat:@"请填写%@",model.name]];
    [self.input setText:model.projectContentValue];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString* str=textField.text;
    NSString* name=self.model.name;
    [self.delegate NumberPassValue:[NSString stringWithFormat:@"%@--%@",str,name]];
}


@end
