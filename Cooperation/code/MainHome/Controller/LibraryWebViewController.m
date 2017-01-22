//
//  LibraryWebViewController.m
//  synergy
//
//  Created by Tion on 17/1/12.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "LibraryWebViewController.h"
#import "CommonWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface LibraryWebViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation LibraryWebViewController
{
    NSString* Url;
    UIButton* back;
    UIButton* title;
    UIBarButtonItem* titleItem;
    
    UIView* NoNetView;
    UIImageView* NoNetImage;
    UIButton* ReloadButton;
    UILabel* NoNetLabel;
}

-(instancetype)initWithUrl:(NSString *)UrlString{
    //传递url
    if (self == [super init]) {
        Url=UrlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self CheckNetWorking];
    
    [self SetBackButton];
}


- (void)SetBackButton{
    //添加返回键
    //UIBarButtonItemStyleDone
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backAction@3x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
//    leftItem.tintColor=[UIColor whiteColor];
//    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    spaceItem.width = - 0;
//    
//    titleItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(titleNothing)];
//    titleItem.tintColor=[UIColor whiteColor];
//    
//    self.navigationItem.leftBarButtonItems = @[spaceItem, leftItem,titleItem];
//    
//    self.tabBarController.tabBar.hidden=YES;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)titleNothing{
    
}


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
                [self SetWebView];
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                //                [weakSelf loadMessage:@"你现在使用的流量"];
                NSLog(@"你现在使用的流量");
                [self SetWebView];
                break;
            }
                
            case AFNetworkReachabilityStatusUnknown: {
                //                [weakSelf loadMessage:@"你现在使用的未知网络"];
                NSLog(@"你现在使用的未知网络");
                [self SetWebView];
                break;
            }
            default:
                break;
        }
    }];
    [manager startMonitoring];
}

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
    
    [titleItem setTitle:status];
}


-(void)SetWebView{
    webView.hidden=NO;
    NoNetView.hidden=YES;
    CGRect rect = [ UIScreen mainScreen ].bounds;
    CGSize size = rect.size;
    //尺寸处有疑义。。因为webview加载url时有一大段空白。起点暂定位0
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAVIGATOR_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATOR_HEIGHT)];
    [webView setUserInteractionEnabled:YES];//是否支持交互
    //[webView setDelegate:self];
    webView.delegate=self;
    
    
    webView.scrollView.delegate=self;
    webView.scrollView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil];
    longPress.delegate = self; //记得在.h文件里加上委托
    longPress.minimumPressDuration = 0.4; //这里为什么要设置0.4，因为只要大于0.5就无效，我像大概是因为默认的跳出放大镜的手势的长按时间是0.5秒，
    //如果我们自定义的手势大于或小于0.5秒的话就来不及替换他的默认手势了，这是只是我的猜测。但是最好大于0.2秒，因为有的pdf有一些书签跳转功能，这个值太小的话可能会使这些功能失效。
    
    [webView addGestureRecognizer:longPress];
    
    
    
    [webView setOpaque:NO];//opaque是不透明的意思
    [webView setScalesPageToFit:YES];//自动缩放以适应屏幕
    [self.view addSubview:webView];
    
    
    //加载网页的方式
    //1.创建并加载远程网页
    NSURL *url = [NSURL URLWithString:Url];
    //@"http://singki.com/synergy_w/wx/productDescs/index?phone=15295750567"
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    //过度页面
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
}

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
        NSLog(@"schemestring=%@",schemeString);
        //拦截器（用于拦截字段并执行js方法）
        if ([[url scheme] isEqualToString:@"showwebview"])
        {
            NSArray *array = [urlString componentsSeparatedByString:@"goUrl=/"]; //从字符A中分隔成2个元素的数组
            NSString* urlpart=[array objectAtIndex:1];
            NSString* NewUrl=[NSString stringWithFormat:@"%@%@",HOST_ADDRESS,urlpart];
            //跳转common页面
            CommonWebViewController* web=[[CommonWebViewController alloc]initWithUrl:NewUrl];
            [self.navigationController pushViewController:web animated:NO];
            return false;
        }
        if([[url scheme] isEqualToString:@"onupload"]){
            [self jumpPicker];
            
            return false;
        }
        //获取url信息
        if ([[url scheme] isEqualToString:@"closewebview"])
        {
            [self.navigationController popViewControllerAnimated:NO];
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
    
    opaqueView.hidden = NO;
    webView.scrollView.scrollEnabled=NO;
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicatorView startAnimating];
    opaqueView.hidden = YES;
    
    NSString* str = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //    [titleItem setTitle:str];
    [titleItem setTitle:@""];
    self.title=str;
    
    [webView.scrollView.mj_header endRefreshing];
    //    webView.scrollView.scrollEnabled=YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle

{
    
    return UIStatusBarStyleLightContent;
    
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
    NSData *imageDatas =UIImageJPEGRepresentation(image, 0.1) ;
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




- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}



@end
