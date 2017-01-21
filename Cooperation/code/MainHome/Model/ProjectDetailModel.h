//
//  ProjectDetailModel.h
//  Cooperation
//
//  Created by yangjuanping on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProjectModel,OfficeModel;

@interface ProjectDetailModel : NSObject

//	√	String	客户经理id（多个用”,”分割）
@property(nonatomic,strong)NSString*userIds;

//	√	String	客户经理名称（多个用”,”分割）
@property(nonatomic,strong)NSString*userNames;

//	√	String	客户经理类型（多个用”,”分割），2:客户经理，3：投行经办人
@property(nonatomic,strong)NSString*userTypes;


//	√	Object	项目信息对象
@property(nonatomic,strong)ProjectModel* project;


//	√	Object	经办支行对象
@property(nonatomic,strong)OfficeModel* office;

//	√	List	融资模式内容集合
@property(nonatomic,strong)NSArray* factors;

//	√	List	放款详情集合
@property(nonatomic,strong)NSArray* credits;

+ (instancetype)creatModelWithDictonary:(NSDictionary *)dictonary;

@end

@interface ProjectModel : NSObject
//	√	String	项目id
@property(nonatomic,strong)NSString* projectId;

//	√	String	项目名称
@property(nonatomic,strong)NSString*projectName;

//	√	String	项目负责人id
@property(nonatomic,strong)NSString*personLiableId;

//	√	String	项目负责人名称
@property(nonatomic,strong)NSString*responsiblePerson;

//	√	int	0:非置顶，1:置顶
@property(nonatomic,assign)NSInteger isTop;

//	√	String	融资模式id

@property(nonatomic,strong)NSString*financingModeId;

//	√	String	融资模式名称
@property(nonatomic,strong)NSString*financingModeName;

//	√	int	是否可以编辑放款详情（0：不可以 1：可以）
@property(nonatomic,assign)NSInteger isEdit;

+ (ProjectModel *)parsingDataWithResult:(NSDictionary *)resultDict;
@end

//office：
@interface OfficeModel : NSObject

//	√	String	机构id
@property(nonatomic,strong)NSString* officeId;

//	√	String	机构名称
@property(nonatomic,strong)NSString* officeName;

+ (OfficeModel *)parsingDataWithResult:(NSDictionary *)resultDict;
@end

@interface FactorModel : NSObject
//	√	String	要素id
@property(nonatomic,strong)NSString* factorId;

//	√	String	要素名称
@property(nonatomic,strong)NSString*name;

//	√	String	要素值
@property(nonatomic,strong)NSString*projectContentValue;

//	√	String	要素值类型
@property(nonatomic,strong)NSString*type;

//	√	String	是否必填（0：必填，1：不必填）
@property(nonatomic,strong)NSString*isRequire;

// 非接口数据，为实现按钮回调而加
@property(nonatomic,assign)SEL action;
@property(nonatomic,strong)UIViewController* parentVC;

+ (NSArray *)parsingDataWithResult:(NSDictionary *)resultDict;
@end

@interface CreditModel : NSObject

//	√	String	放款日（或放款金额）
@property(nonatomic,strong)NSString*name;

 //	√	String	数值
@property(nonatomic,strong)NSString*projectContentValue;

//	√	String	放款类型（0：未放款，1：部分放款，2：全部放款）
@property(nonatomic,strong)NSString*type;

+ (NSArray *)parsingDataWithResult:(NSDictionary *)resultDict;
@end


@interface ChangeInfoModel : NSObject
// 修改者姓名
@property(nonatomic,strong)NSString* handlers;

// 原始金额
@property(nonatomic,strong)NSString* originalAmount;

// 修改前借款人
@property(nonatomic,strong)NSString* originalName;

// 修改后的金额
@property(nonatomic,strong)NSString* amount;

// 修改后的借款人
@property(nonatomic,strong)NSString* name;

// 操作时间
@property(nonatomic,strong)NSString* time;
@end



