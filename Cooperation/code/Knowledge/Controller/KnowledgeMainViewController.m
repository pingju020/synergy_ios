//
//  KnowledgeMainViewController.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/20.
//  Copyright © 2017年 yangjuanping. All rights reserved.
//

#import "KnowledgeMainViewController.h"
#import "PJTabBarItem.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LibraryWebViewController.h"
@interface KnowledgeMainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate>
@end

@implementation KnowledgeMainViewController
{
    CGFloat margin;
    
    UIButton* TempButton1;
    UIButton* TempButton2;
    UIButton* TempButton3;
    UIButton* TempButton4;
    
    UIView* barview;
    
    UIWebView* WebView;
    
        UIButton* back;
        UIButton* title;
        
        UIView* NoNetView;
        UIImageView* NoNetImage;
        UIButton* ReloadButton;
        UILabel* NoNetLabel;
        UIBarButtonItem *leftItem;
}
AH_BASESUBVCFORMAINTAB_MODULE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    margin=0;
    
    [self SettingTopBar];
    
    [self CheckNetWorking];
//    [self SettingWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(PJTabBarItem*)getTabBarItem{
    //
    PJTabBarItem* itemMainHome = [[PJTabBarItem alloc]init];
    itemMainHome.strTitle = @"知识库";
    itemMainHome.strNormalImg = @"knowledge@2x.png";
    itemMainHome.strSelectImg = @"knowledge_press@2x.png";
    itemMainHome.viewController = self;
    itemMainHome.tabIndex = 3;
    //title.text = itemMainHome.strTitle;
    [self setTitle:itemMainHome.strTitle];
    return itemMainHome;
}

#pragma mark 监测网络
-(void)CheckNetWorking{
    AFNetworkReachabilityManager *manager=[AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: {
                //                [weakSelf loadMessage:@"网络不可用"];
                NSLog(@"网络不可用");
                //显示过度页面
                [self SetNoNetViewWithStatusString:@"网络不可用"];
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                //                [weakSelf loadMessage:@"Wifi已开启"];
                NSLog(@"Wifi已开启");
                [self SettingWebView];
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                //                [weakSelf loadMessage:@"你现在使用的流量"];
                NSLog(@"你现在使用的流量");
                [self SettingWebView];
                break;
            }
                
            case AFNetworkReachabilityStatusUnknown: {
                //                [weakSelf loadMessage:@"你现在使用的未知网络"];
                NSLog(@"你现在使用的未知网络");
                [self SettingWebView];
                break;
            }
            default:
                break;
        }
    }];
    [manager startMonitoring];
}


#pragma mark Tab设定（顶部控制切换webview的url）
-(void)SettingTopBar{
    UIView* BackGround=[[UIView alloc]initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT,SCREEN_WIDTH,50)];
//    [BackGround setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:BackGround];
    CGFloat averageWidth=SCREEN_WIDTH/4-margin/2;
    NSArray* arr=[NSArray arrayWithObjects:@"投行周报",@"消息推送",@"市场快报",@"产品说明", nil];
    
    TempButton1=[[UIButton alloc]initWithFrame:CGRectMake(margin,0,averageWidth,48)];
    [TempButton1 setTitle:@"投行周报" forState:UIControlStateNormal];
    [TempButton1 setTag:0];
    [TempButton1 addTarget:self action:@selector(ClickTabView:) forControlEvents:UIControlEventTouchUpInside];
    [TempButton1 setTitleColor:[UIColor colorWithHexString:@"#868686"] forState:UIControlStateNormal];
    [BackGround addSubview:TempButton1];
    
    TempButton2=[[UIButton alloc]initWithFrame:CGRectMake(margin+averageWidth,0,averageWidth,48)];
    [TempButton2 setTitle:@"消息推送" forState:UIControlStateNormal];
    [TempButton2 setTag:1];
    [TempButton2 addTarget:self action:@selector(ClickTabView:) forControlEvents:UIControlEventTouchUpInside];
    [TempButton2 setTitleColor:[UIColor colorWithHexString:@"#868686"] forState:UIControlStateNormal];
    [BackGround addSubview:TempButton2];
    
    TempButton3=[[UIButton alloc]initWithFrame:CGRectMake(margin+averageWidth*2,0,averageWidth,48)];
    [TempButton3 setTitle:@"市场快报" forState:UIControlStateNormal];
    [TempButton3 setTag:2];
    [TempButton3 addTarget:self action:@selector(ClickTabView:) forControlEvents:UIControlEventTouchUpInside];
    [TempButton3 setTitleColor:[UIColor colorWithHexString:@"#868686"] forState:UIControlStateNormal];
    [BackGround addSubview:TempButton3];
    
    TempButton4=[[UIButton alloc]initWithFrame:CGRectMake(margin+averageWidth*3,0,averageWidth,48)];
    [TempButton4 setTitle:@"产品说明" forState:UIControlStateNormal];
    [TempButton4 setTag:3];
    [TempButton4 addTarget:self action:@selector(ClickTabView:) forControlEvents:UIControlEventTouchUpInside];
    [TempButton4 setTitleColor:[UIColor colorWithHexString:@"#868686"] forState:UIControlStateNormal];
    [BackGround addSubview:TempButton4];
    
    barview=[[UIView alloc]initWithFrame:CGRectMake(margin,48,SCREEN_WIDTH/4-margin/2, 2)];
    [barview setBackgroundColor:[UIColor colorWithHexString:@"#00BCF2"]];
    [BackGround addSubview:barview];
    
}

-(void)ClickTabView:(UIButton*)btn
{
    NSInteger TempNumber=btn.tag;
    [barview setFrame:CGRectMake(SCREEN_WIDTH/4*TempNumber, 48, SCREEN_WIDTH/4-margin/2, 2)];
    
    NSMutableArray* arr=[NSMutableArray new];
    
    NSString* TempString1=[NSString stringWithFormat:@"http://singki.com/synergy_w/wx/productDescs/inBankWeekLyList"];
    NSURL *url1 = [NSURL URLWithString:TempString1];
    
    
    NSString* TempString2=[NSString stringWithFormat:@"http://singki.com/synergy_w/wx/productDescs/inforPushList"];
    NSURL *url2 = [NSURL URLWithString:TempString2];
    
    NSString* TempString3=[NSString stringWithFormat:@"http://singki.com/synergy_w/wx/productDescs/marketReportList"];
    NSURL *url3 = [NSURL URLWithString:TempString3];
    
    NSString* TempString4=[NSString stringWithFormat:@"http://singki.com/synergy_w/wx/productDescs/product"];
    NSURL *url4 = [NSURL URLWithString:TempString4];
    [arr addObject:url1];
    [arr addObject:url2];
    [arr addObject:url3];
    [arr addObject:url4];
    //加载不同网址
    switch (TempNumber) {
        case 0:
            
            [WebView loadRequest:[NSURLRequest requestWithURL:[arr objectAtIndex:0]]];
            break;
        case 1:
            
            [WebView loadRequest:[NSURLRequest requestWithURL:[arr objectAtIndex:1]]];
            break;
        case 2:
            
            [WebView loadRequest:[NSURLRequest requestWithURL:[arr objectAtIndex:2]]];
            break;
        case 3:
        
            [WebView loadRequest:[NSURLRequest requestWithURL:[arr objectAtIndex:3]]];
            break;
        default:
            break;
    }
    
}

#pragma mark webview
-(void)SetNoNetViewWithStatusString:(NSString*)status{
    webView.hidden=YES;
    NoNetView.hidden=NO;
    
    NoNetView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    [NoNetView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:NoNetView];
    
    NoNetImage=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT/4, 100, SCREEN_HEIGHT/8)];
    [NoNetImage setImage:[UIImage imageNamed:@"no_web.png"]];
    [NoNetView addSubview:NoNetImage];
    
    NoNetLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*3/8, SCREEN_WIDTH, SCREEN_HEIGHT/16-5)];
    [NoNetLabel setTextAlignment:NSTextAlignmentCenter];
    [NoNetLabel setText:status];
    [NoNetLabel setTextColor:[UIColor colorWithHexString:@"#EAEAEA"]];
    [NoNetView addSubview:NoNetLabel];
    
    ReloadButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT*3/8+SCREEN_HEIGHT/16+5,100, SCREEN_HEIGHT/16-5)];
    [ReloadButton setBackgroundColor:[UIColor colorWithHexString:@"#FC6E3A"]];
    [ReloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [ReloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ReloadButton addTarget:self action:@selector(CheckNetWorking) forControlEvents:UIControlEventTouchUpInside];
    [NoNetView addSubview:ReloadButton];
    
    [leftItem setTitle:status];
}


-(void)SettingWebView{
    UIView* LineView=[[UIView alloc]initWithFrame:CGRectMake(0,NAVIGATOR_HEIGHT+STATUS_BAR_HEIGHT+50,SCREEN_WIDTH,10)];
    [LineView setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
    [self.view addSubview:LineView];
    
    
    
    WebView=[[UIWebView alloc]initWithFrame:CGRectMake(0,NAVIGATOR_HEIGHT+STATUS_BAR_HEIGHT+60, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATOR_HEIGHT-STATUS_BAR_HEIGHT-60-TAB_BAR_HEIGHT)];
    [self.view addSubview:WebView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    webView.hidden=NO;
    NoNetView.hidden=YES;
    CGRect rect = [ UIScreen mainScreen ].bounds;
    CGSize size = rect.size;
    
    [WebView setUserInteractionEnabled:YES];//是否支持交互
    WebView.delegate=self;
    
    
    
    WebView.scrollView.delegate=self;
    WebView.scrollView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil];
    longPress.delegate = self; //记得在.h文件里加上委托
    longPress.minimumPressDuration = 0.4; //这里为什么要设置0.4，因为只要大于0.5就无效，我像大概是因为默认的跳出放大镜的手势的长按时间是0.5秒，
    //如果我们自定义的手势大于或小于0.5秒的话就来不及替换他的默认手势了，这是只是我的猜测。但是最好大于0.2秒，因为有的pdf有一些书签跳转功能，这个值太小的话可能会使这些功能失效。
    [WebView addGestureRecognizer:longPress];

    
//    [WebView setOpaque:NO];//opaque是不透明的意思
    [WebView setScalesPageToFit:YES];//自动缩放以适应屏幕
    [self.view addSubview:WebView];
    //加载网页的方式
    //1.创建并加载远程网页
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username=[UserDefaults objectForKey:@"user"];
    NSString* TempString=[NSString stringWithFormat:@"http://singki.com/synergy_w/wx/productDescs/inBankWeekLyList"];
    NSURL *url = [NSURL URLWithString:TempString];
    [WebView loadRequest:[NSURLRequest requestWithURL:url]];
    //2.过度
    opaqueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,size.width, size.height)];
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0,size.width, size.height)];
    [activityIndicatorView setCenter:opaqueView.center];
    [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [opaqueView setBackgroundColor:[UIColor blackColor]];
    [opaqueView setAlpha:0.2];
    [self.view addSubview:opaqueView];
    [opaqueView addSubview:activityIndicatorView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [webView setBackgroundColor:[UIColor whiteColor]];
    
    opaqueView.hidden=YES;
}

#pragma mark 代理

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判定网络状态状态
    static BOOL isRequest = YES;
    if (isRequest) {
        NSHTTPURLResponse *response = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request   returningResponse:&response error:nil];
        //获取url和[url scheme]
        NSURL * url = [request URL];
        NSString* urlString=[NSString stringWithFormat:@"%@",url];
        NSString* schemeString=[url scheme];
        //拦截器（用于拦截字段并执行js方法）
        if ([[url scheme] isEqualToString:@"showwebview"])
        {
            NSArray *array = [urlString componentsSeparatedByString:@"goUrl=/"]; //从字符A中分隔成2个元素的数组
            NSString* urlpart=[array objectAtIndex:1];
            NSString* NewUrl=[NSString stringWithFormat:@"%@%@",HOST_ADDRESS,urlpart];
            //跳转common页面
            LibraryWebViewController* web=[[LibraryWebViewController alloc]initWithUrl:NewUrl];
            [self.navigationController pushViewController:web animated:NO];
            return false;
        }
        NSLog(@"--status---%ld",response.statusCode);
        if([[url scheme] isEqualToString:@"onupload"]){
            [self jumpPicker];
            
            return false;
        }
        if(response.statusCode != 200)
        {
            NSLog(@"加载异常");
            [self SetNoNetViewWithStatusString:@"服务异常"];
            return NO;
        }
    }
    
    return true;
}


-(void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicatorView startAnimating];
    opaqueView.hidden = YES;
    webView.scrollView.scrollEnabled=NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicatorView startAnimating];
    opaqueView.hidden = YES;
    
    NSString* str = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    self.title=@"汇总";
    [leftItem setTitle:@""];
    [webView.scrollView.mj_header endRefreshing];
    webView.scrollView.scrollEnabled=YES;
    //    self.title=str;
    //禁用长按copy和selected
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
}

//UIWebView如何判断 HTTP 404 等错误
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ((([httpResponse statusCode]/100) == 2)) {
        // self.earthquakeData = [NSMutableData data];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [ webView loadRequest:[ NSURLRequest requestWithURL: url]];
        webView.delegate = self;
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  NSLocalizedString(@"HTTP Error",
                                                    @"Error message displayed when receving a connection error.")
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:userInfo];
        
        if ([error code] == 404) {
            NSLog(@"xx");
            webView.hidden = YES;
        }
        
    }
}

#pragma mark 状态事件
- (void)backAction{
    
}

- (void)headerRefresh{
    [self CheckNetWorking];
}

#pragma mark 图片picker
//跳转picker页面
-(void)jumpPicker{
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
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //    NSString *url=@"http://192.168.0.198/synergy/wx/uploadfile/upload";
    
    NSString *url=[NSString stringWithFormat:@"%@uploadfile/upload",HOST_ADDRESS];
    NSMutableDictionary* dic=[NSMutableDictionary new];
    [dic setValue:@"file" forKey:@"file"];
    NSURLSessionDataTask *task = [manager POST:url
                                    parameters:dic
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
                                           NSLog(@"图片上传成功");
                                           
                                           NSString* fileurl=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
                                           NSString* filename=[responseObject objectForKey:@"fileName"];
                                           
                                           JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
                                           NSString* TempString=[NSString stringWithFormat:@"iosToJs('%@','%@')",fileurl,filename];
                                           [context evaluateScript:TempString];
                                           
                                       }
                                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           //上传失败
                                           NSLog(@"上传失败");
                                           NSLog(@"%@",error);
                                       }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
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
