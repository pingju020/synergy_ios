//
//  BaseMainViewController.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "BaseMainViewController.h"
#import "ViewButtonModel.h"
#import "BaseInfomationViewController.h"
#import "ProjectStageViewController.h"

//带下划线的按钮
@interface LineButton : UIButton
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) NSString *myId;
- (instancetype)initWithFrame:(CGRect)frame needBottomLine:(BOOL)needBottomLine; //default YES 默认带下划线
@end


@interface BaseMainViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (nonatomic,strong) UIPageViewController *pageVC;

@property (nonatomic,strong) NSArray              *dataList;

@property (nonatomic,assign) NSInteger             page;

@property(nonatomic,strong)UIScrollView*           scorllView;

@property (nonatomic,strong) NSString* projectId;
@property (nonatomic,strong) NSString* projectName;
@end

@implementation BaseMainViewController

-(id)initWithProjretId:(NSString*)projectId Name:(NSString*)name{
    if (self = [super init]) {
        _projectId = projectId;
        _projectName = name;
    }
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    title.text = _projectName;
    [super viewDidLoad];
    [self initData];
    [self initView];
}


-(void)initData
{
    NSMutableArray *mulArr = [NSMutableArray array];
    
    ViewButtonModel* modelInfo = [[ViewButtonModel alloc]init];
    modelInfo.vc = [[BaseInfomationViewController alloc]initWithProjectId:_projectId ProjectName:_projectName type:E_INFO_VIEW];
    modelInfo.Name = @"基本信息";
    [mulArr addObject:modelInfo];
    
    ViewButtonModel* modelProgress = [[ViewButtonModel alloc]init];
    modelProgress.vc = [[ProjectStageViewController alloc]initWithProjectId:@""];
    modelProgress.Name = @"进展";
    [mulArr addObject:modelProgress];
    
    ViewButtonModel* modelMsg = [[ViewButtonModel alloc]init];
    modelMsg.vc = [[ProjectStageViewController alloc]initWithProjectId:@""];
    modelMsg.Name = @"消息";
    [mulArr addObject:modelMsg];
    
    ViewButtonModel* modelPersons = [[ViewButtonModel alloc]init];
    modelPersons.vc = [[ProjectStageViewController alloc]initWithProjectId:@""];
    modelPersons.Name = @"成员";
    [mulArr addObject:modelPersons];
    
    _dataList = [mulArr copy];
    
    _page = 0;
}

-(UIScrollView*)scorllView{
    if (!_scorllView) {
        _scorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH, 44)];
        for (NSInteger index = 0; index<4; index++) {
            ViewButtonModel* model = _dataList[index];
            LineButton* btn = [[LineButton alloc]initWithFrame:CGRectMake(index*(MAIN_WIDTH/4), 0, MAIN_WIDTH/4, 44) needBottomLine:YES];
            [btn setTitle:model.Name forState:UIControlStateNormal];
            btn.tag = index;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_scorllView addSubview:btn];
        }
        [self.view addSubview:_scorllView];
    }
    
    return _scorllView;
}

#pragma mark -UIPageViewControllerDelegate
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    _page--;
    
    if (_page<0) {
        _page = _dataList.count - 1;
    }
    
    ViewButtonModel* model = _dataList[_page];
    return model.vc;
}
//后一个
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    _page++;
    if (_page>=_dataList.count) {
        
        _page = 0;
    }
    
    ViewButtonModel* model = _dataList[_page];
    return model.vc;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    //NSInteger index = ((SubTableViewController *)pageViewController.viewControllers[0]).page;
}

#pragma mark -setUI
-(void)initView
{
    [self.view addSubview:self.pageVC.view];
    
    //[_pageVC.view addSubview:self.segmentedConrol];
    
}

-(UIPageViewController *)pageVC
{
    if (!_pageVC) {
        
        _pageVC = [[UIPageViewController alloc]initWithTransitionStyle:1
                                                 navigationOrientation:0
                                                               options:nil];
        
        ViewButtonModel* model = _dataList[0];
        [_pageVC setViewControllers:@[model.vc] direction:0 animated:YES completion:nil];
        
        _pageVC.delegate   = self;
        
        _pageVC.dataSource = self;
        
    }
    return _pageVC;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)btnClicked:(LineButton*)sender{
    ;
}

@end

#pragma mark -下划线的蓝色按钮

@implementation LineButton

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame needBottomLine:YES];
}

- (instancetype)initWithFrame:(CGRect)frame needBottomLine:(BOOL)needBottomLine
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:kCommonColorHighLight forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        
        if (needBottomLine) {
            [self line];
        }
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (_line) {
        self.line.backgroundColor = selected ? kCommonColorHighLight : VcBackgroudColor;
    }
    
    
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        _line.backgroundColor = VcBackgroudColor;
        [self addSubview:_line];
    }
    return _line;
}

@end