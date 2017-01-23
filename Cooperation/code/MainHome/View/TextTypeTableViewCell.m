//
//  TextTypeTableViewCell.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "TextTypeTableViewCell.h"
#import "ProjectDetailModel.h"

@interface TextTypeTableViewCell()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField* input;
@property(nonatomic,strong)UIView* sep;
@end

@implementation TextTypeTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _input = [[UITextField alloc]initWithFrame:CGRectMake(140, 0, MAIN_WIDTH - 140-20, 53)];
        [_input setTextAlignment:NSTextAlignmentRight];
        [_input setTextColor:COMMON_CORLOR_HIGHLIGHT];
        [_input setFont:[UIFont systemFontOfSize:14]];
        _input.delegate = self;
        [self.contentView addSubview:_input];
        
        [self.textLabel setFont:[UIFont systemFontOfSize:14]];
        [self.textLabel setTextColor:[UIColor darkGrayColor]];
        [self.textLabel setTextAlignment:NSTextAlignmentLeft];
        [self.textLabel setWidth:60];
        self.textLabel.numberOfLines = 0;
        
        _sep = [[UIView alloc]initWithFrame:CGRectMake(0, 55, MAIN_WIDTH, 1)];
        [_sep setBackgroundColor:VcBackgroudColor];
        [self.contentView addSubview:_sep];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(FactorModel *)model{
    _model = model;
    [self.self.textLabel setText:model.name];
    if ([_model.type isEqualToString:@"text"]) {
       [self.input setPlaceholder:[NSString stringWithFormat:@"请填写%@",model.name]];
    }
    [self.input setText:model.projectContentValue];
}


#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([_model.type isEqualToString:@"text"]) {
        return YES;
    }
    else{
        return NO;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString* str=textField.text;
    NSString* name=self.model.name;
    [self.delegate PassValue:[NSString stringWithFormat:@"%@--%@",str,name]];
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    NSString* str=textField.text;
//    NSString* name=self.model.name;
//    [self.delegate PassValue:[NSString stringWithFormat:@"%@--%@",str,name]];
//}



@end
