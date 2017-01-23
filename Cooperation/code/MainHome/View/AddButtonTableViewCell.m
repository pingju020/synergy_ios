//
//  AddButtonTableViewCell.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "AddButtonTableViewCell.h"
#import "ProjectDetailModel.h"

@interface AddButtonTableViewCell()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField* input;
@property(nonatomic,strong)UIButton* addButton;
@property(nonatomic,strong)UIView* sep;
@end

@implementation AddButtonTableViewCell

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
        
        _addButton = [[UIButton alloc]initWithFrame:CGRectMake(MAIN_WIDTH-30, 18, 20, 20)];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"新增@3x.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_addButton];
        
        
        _input = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.textLabel.frame)+10, 0, CGRectGetMinX(_addButton.frame)-CGRectGetMaxX(self.textLabel.frame)-10, 56)];
        [_input setTextAlignment:NSTextAlignmentRight];
        [_input setTextColor:COMMON_CORLOR_HIGHLIGHT];
        [_input setFont:[UIFont systemFontOfSize:14]];
        _input.delegate = self;
        [self.contentView addSubview:_input];
        
        _sep = [[UIView alloc]initWithFrame:CGRectMake(0, 55, MAIN_WIDTH, 1)];
        [_sep setBackgroundColor:VcBackgroudColor];
        [self.contentView addSubview:_sep];
    }
    return self;
}

-(void)setModel:(FactorModel *)model{
    _model = model;
    [self.self.textLabel setText:model.name];
    [self.input setPlaceholder:[NSString stringWithFormat:@"请选择%@",model.name]];
    [self.input setText:model.projectContentValue];
    if (_model.parentVC && _model.action) {
        [self.addButton addTarget:_model.parentVC action:_model.action forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString* str=textField.text;
    NSString* name=self.model.name;
    [self.delegate AddPassValue:[NSString stringWithFormat:@"add---%@--%@",str,name]];
}

@end
