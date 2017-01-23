//
//  MessageViewController.m
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "MessageViewController.h"
#import "XHDisplayTextViewController.h"
#import "XHDisplayMediaViewController.h"
#import "XHDisplayLocationViewController.h"
#import "XHAudioPlayerHelper.h"

#import "NSDictionary+LJAdditions.h"
#import "LJMacros.h"
#import "NSString+LJAdditions.h"
#import "NSDate+LJAdditions.h"
#import "NSObject+LJAdditions.h"
#import "NSArray+LJAdditions.h"

#import "AppDelegate.h"

dispatch_source_t LJGCDTimer(NSTimeInterval interval,
                             NSTimeInterval leeway,
                             dispatch_block_t handler,
                             dispatch_block_t cancelHandler)
{
    double t = interval * NSEC_PER_SEC;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, t, leeway * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, handler);
    if (cancelHandler) {
        dispatch_source_set_cancel_handler(timer, cancelHandler);
    }
    dispatch_resume(timer);
    return timer;
}


@interface MessageViewController () <XHAudioPlayerHelperDelegate>

@property (nonatomic, strong) NSArray *emotionManagers;

@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;

@property (nonatomic,strong) NSNumber* maxMessageId;

@property (nonatomic,strong) NSTimer* timer;

@end

@implementation MessageViewController

-(void)backBtnClicked{
    if (_backVC) {
        [_backVC backBtnClicked];
    }
    else{
        [super backBtnClicked];
    }
}

- (XHMessage *)getTextMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *textMessage = [[XHMessage alloc] initWithText:@"这是华捷微信，希望大家喜欢这个开源库，请大家帮帮忙支持这个开源库吧！我是Jack，叫华仔也行，曾宪华就是我啦！" sender:@"华仔" timestamp:[NSDate distantPast]];
    textMessage.avatar = [UIImage imageNamed:@"avatar"];
    textMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/meIcon@2x.png";
    textMessage.bubbleMessageType = bubbleMessageType;
    
    return textMessage;
}

- (XHMessage *)getPhotoMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:nil thumbnailUrl:@"http://d.hiphotos.baidu.com/image/pic/item/30adcbef76094b361721961da1cc7cd98c109d8b.jpg" originPhotoUrl:nil sender:@"Jack" timestamp:[NSDate date]];
    photoMessage.avatar = [UIImage imageNamed:@"avatar"];
    photoMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/JieIcon@2x.png";
    photoMessage.bubbleMessageType = bubbleMessageType;
    
    return photoMessage;
}

- (XHMessage *)getVideoMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"IMG_1555.MOV" ofType:@""];
    XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:[XHMessageVideoConverPhotoFactory videoConverPhotoWithVideoPath:videoPath] videoPath:videoPath videoUrl:nil sender:@"Jayson" timestamp:[NSDate date]];
    videoMessage.avatar = [UIImage imageNamed:@"avatar"];
    videoMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/JieIcon@2x.png";
    videoMessage.bubbleMessageType = bubbleMessageType;
    
    return videoMessage;
}

- (XHMessage *)getVoiceMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:nil voiceUrl:nil voiceDuration:@"1" sender:@"Jayson" timestamp:[NSDate date] isRead:NO];
    voiceMessage.avatar = [UIImage imageNamed:@"avatar"];
    voiceMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/JieIcon@2x.png";
    voiceMessage.bubbleMessageType = bubbleMessageType;
    
    return voiceMessage;
}

- (XHMessage *)getEmotionMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *emotionMessage = [[XHMessage alloc] initWithEmotionPath:[[NSBundle mainBundle] pathForResource:@"emotion1.gif" ofType:nil] sender:@"Jayson" timestamp:[NSDate date]];
    emotionMessage.avatar = [UIImage imageNamed:@"avatar"];
    emotionMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/JieIcon@2x.png";
    emotionMessage.bubbleMessageType = bubbleMessageType;
    
    return emotionMessage;
}

- (XHMessage *)getGeolocationsMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *localPositionMessage = [[XHMessage alloc] initWithLocalPositionPhoto:[UIImage imageNamed:@"Fav_Cell_Loc"] geolocations:@"中国广东省广州市天河区东圃二马路121号" location:[[CLLocation alloc] initWithLatitude:23.110387 longitude:113.399444] sender:@"Jack" timestamp:[NSDate date]];
    localPositionMessage.avatar = [UIImage imageNamed:@"avatar"];
    localPositionMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/meIcon@2x.png";
    localPositionMessage.bubbleMessageType = bubbleMessageType;
    
    return localPositionMessage;
}

- (NSMutableArray*) generateMessage:(NSArray*)rawData reverse:(BOOL)reverse maxId:(NSNumber**)maxId{
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    NSString* myUID = [[NSUserDefaults standardUserDefaults]stringForKey:@"userId"];

    BOOL first = YES;
    for (NSDictionary* item in rawData) {
        if (first) {
            
            NSString* temp = [item lj_stringForKey:@"id"];
            NSNumberFormatter *f = [[NSNumberFormatter alloc]init];
            NSNumber* temp1 = [f numberFromString:temp];
            *maxId = temp1;
            first = NO;
        }
        
        NSString* sendUserId = [item lj_stringForKey:@"sendUserId"];
        if ([sendUserId isEqualToString:myUID]) {
            //自己
            NSNumber* contentType = [item lj_numberForKey:@"contentType" default:@0];
            if ([contentType isEqualToNumber:@1]) {
                //文字
                XHMessage *textMessage = [[XHMessage alloc] initWithText:[item lj_stringForKey:@"content"] sender:[item lj_stringForKey:@"sendUserName"] timestamp:[[item lj_stringForKey:@"completeTime"]lj_dateWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
                textMessage.avatar = [UIImage imageNamed:@"avatar"];
                textMessage.avatarUrl = [item lj_stringForKey:@"sendUserImageUrl"];
                textMessage.bubbleMessageType = XHBubbleMessageTypeSending;
                [textMessage lj_setValue:item forKey:@"rawData"];
                
                
                [messages addObject:textMessage];
            } else if([contentType isEqualToNumber:@7]){
                //图片
                XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:nil thumbnailUrl:[item lj_stringForKey:@"fileUrl"] originPhotoUrl:[item lj_stringForKey:@"fileUrl"] sender:[item lj_stringForKey:@"sendUserName"] timestamp:[[item lj_stringForKey:@"completeTime"]lj_dateWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
                photoMessage.avatar = [UIImage imageNamed:@"avatar"];
                photoMessage.avatarUrl = [item lj_stringForKey:@"sendUserImageUrl"];
                photoMessage.bubbleMessageType = XHBubbleMessageTypeSending;
                [photoMessage lj_setValue:item forKey:@"rawData"];
                
                [messages addObject:photoMessage];
            }else if([contentType isEqualToNumber:@15]){
                //语音
                XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:nil voiceUrl:[item lj_stringForKey:@"fileUrl"] voiceDuration:@"3" sender:[item lj_stringForKey:@"sendUserName"] timestamp:[[item lj_stringForKey:@"completeTime"]lj_dateWithFormat:@"yyyy-MM-dd HH:mm:ss"] isRead:YES];
                voiceMessage.avatar = [UIImage imageNamed:@"avatar"];
                voiceMessage.avatarUrl = [item lj_stringForKey:@"sendUserImageUrl"];
                voiceMessage.bubbleMessageType = XHBubbleMessageTypeSending;
                [voiceMessage lj_setValue:item forKey:@"rawData"];
                
                [messages addObject:voiceMessage];
            }
        } else {
            //别人
            NSNumber* contentType = [item lj_numberForKey:@"contentType" default:@0];
            if ([contentType isEqualToNumber:@1]) {
                //文字
                XHMessage *textMessage = [[XHMessage alloc] initWithText:[item lj_stringForKey:@"content"] sender:[item lj_stringForKey:@"sendUserName"] timestamp:[[item lj_stringForKey:@"completeTime"]lj_dateWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
                textMessage.avatar = [UIImage imageNamed:@"avatar"];
                textMessage.avatarUrl = [item lj_stringForKey:@"sendUserImageUrl"];
                textMessage.bubbleMessageType = XHBubbleMessageTypeReceiving;
                [textMessage lj_setValue:item forKey:@"rawData"];
                [messages addObject:textMessage];
            } else if([contentType isEqualToNumber:@7]){
                //图片
                XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:nil thumbnailUrl:[item lj_stringForKey:@"fileUrl"] originPhotoUrl:[item lj_stringForKey:@"fileUrl"] sender:[item lj_stringForKey:@"sendUserName"] timestamp:[[item lj_stringForKey:@"completeTime"]lj_dateWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
                photoMessage.avatar = [UIImage imageNamed:@"avatar"];
                photoMessage.avatarUrl = [item lj_stringForKey:@"sendUserImageUrl"];
                photoMessage.bubbleMessageType = XHBubbleMessageTypeReceiving;
                [photoMessage lj_setValue:item forKey:@"rawData"];
                [messages addObject:photoMessage];
            }
            else if([contentType isEqualToNumber:@15]){
                //语音
                XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:nil voiceUrl:[item lj_stringForKey:@"fileUrl"] voiceDuration:@"3" sender:[item lj_stringForKey:@"sendUserName"] timestamp:[[item lj_stringForKey:@"completeTime"]lj_dateWithFormat:@"yyyy-MM-dd HH:mm:ss"] isRead:YES];
                voiceMessage.avatar = [UIImage imageNamed:@"avatar"];
                voiceMessage.avatarUrl = [item lj_stringForKey:@"sendUserImageUrl"];
                voiceMessage.bubbleMessageType = XHBubbleMessageTypeReceiving;
                [voiceMessage lj_setValue:item forKey:@"rawData"];
                
                [messages addObject:voiceMessage];
            }
        }
    }
    
    if (reverse) {
        messages=[[[messages reverseObjectEnumerator] allObjects] mutableCopy];
    }
    
    return messages;
}

- (NSNumber*) maxMessageId{
    if (nil == _maxMessageId) {
        _maxMessageId = @0;
    }
    return _maxMessageId;
}

- (NSString*) projectId{
    if (nil == _projectId) {
        _projectId = @"";
    }
    return _projectId;
}

- (void )getStartMessages {
    @weakify(self)
    
    
    [HTTP_MANAGER startNormalPostWithParagram:@{@"phone":[[NSUserDefaults standardUserDefaults]objectForKey:@"user"],@"projectId":self.projectId,@"messageId":self.maxMessageId} Commandtype:@"app/message/getMoreMessage" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        NSLog(@"开始消息%@",succeedResult);
        NSNumber* ret =  [succeedResult lj_numberForKey:@"ret"];
        if ([ret isEqualToNumber:@0]) {
            //成功
            @strongify(self)
            NSNumber* maxId = nil;
            self.messages = [self generateMessage:[succeedResult lj_arrayForKey:@"data"] reverse:YES maxId:&maxId];
            if (maxId) {
                self.maxMessageId = maxId;
            }
            [self.messageTableView reloadData];
            [self scrollToBottomAnimated:NO];
            
            
            
        }
        //开始轮询
        [self startLoop];
    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
        //开始轮询
        [self startLoop];
    }];
    
}

- (void)loadMessageDataSource {
    [self getStartMessages];
}

-(void)sendVoiceMessage:(NSString*)filePath dur:(NSString*)dur{
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
    
 //   manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"*/*",
 //                                                        nil];
    
    NSString *url=[NSString stringWithFormat:@"%@uploadfile/upload",HOST_ADDRESS];
    NSMutableDictionary* dic=[NSMutableDictionary new];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] forKey:@"phone"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.m4a", str];
    
    NSURLSessionDataTask* task = [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
                                  {
                                      NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                                      
                                      //上传的参数(上传图片，以文件流的格式)
                                      [formData appendPartWithFileData:fileData
                                                                  name:@"file"
                                                              fileName:fileName
                                                              mimeType:@"audio/m4a"];
                                  }
                                      progress:^(NSProgress * _Nonnull uploadProgress) {
                                          //打印下上传进度
                                          NSLog(@"上传进度");
                                          NSLog(@"%@",uploadProgress);
                                      }
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           //上传成功
                                           NSLog(@"上传成功");
                                           NSString* imageUrl=[responseObject objectForKey:@"data"];
                                           [HTTP_MANAGER startNormalPostWithParagram:@{@"phone":[[NSUserDefaults standardUserDefaults]objectForKey:@"user"],@"projectId":self.projectId,@"fileUrl":imageUrl,@"fileName":fileName} Commandtype:@"app/message/addMessage" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                                               NSLog(@"发送图片成功");
                                               [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
                                               
                                           } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                                               NSLog(@"发送图片失败");
                                           }];
                                       }
                                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           //上传失败
                                           NSLog(@"上传失败");
                                           NSLog(@"%@",error);
                                       }];
}

-(void)sendImageMessage:(UIImage*)image{
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
    
    NSString *url=[NSString stringWithFormat:@"%@uploadfile/upload",HOST_ADDRESS];
    NSMutableDictionary* dic=[NSMutableDictionary new];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] forKey:@"phone"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    NSURLSessionDataTask* task = [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         NSData *imageDatas =UIImageJPEGRepresentation(image, 0.1) ;
         
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
              NSLog(@"上传成功");
              NSString* imageUrl=[responseObject objectForKey:@"data"];
              [HTTP_MANAGER startNormalPostWithParagram:@{@"phone":[[NSUserDefaults standardUserDefaults]objectForKey:@"user"],@"projectId":self.projectId,@"fileUrl":imageUrl,@"fileName":fileName} Commandtype:@"app/message/addMessage" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                  NSLog(@"发送图片成功");
                  [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];
                  
              } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                  NSLog(@"发送图片失败");
              }];
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              //上传失败
              NSLog(@"上传失败");
              NSLog(@"%@",error);
          }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadMessageDataSource];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (nil !=self.timer && [self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [[XHAudioPlayerHelper shareInstance] stopAudio];
}

- (id)init {
    self = [super init];
    if (self) {
        // 配置输入框UI的样式
                self.allowsSendVoice = YES;
                self.allowsSendFace = NO;
                self.allowsSendMultiMedia = YES;
    }
    return self;
}

- (void) appendMessages:(NSArray*)msgs{
    [self.messages addObjectsFromArray:msgs];
    [self.messageTableView reloadData];
    [self scrollToBottomAnimated:YES];
//    for (XHMessage* msg in msgs) {
//        [self addMessage:msg];
//        [self finishSendMessageWithBubbleMessageType:msg.messageMediaType];
//        break;
//    }
}

- (void) fireTimer:(id)timer{
    @weakify(self)

    [HTTP_MANAGER startNormalPostWithParagram:@{@"phone":[[NSUserDefaults standardUserDefaults]objectForKey:@"user"],@"projectId":self.projectId,@"messageId":self.maxMessageId} Commandtype:@"app/message/getMoreMessage" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        
        NSNumber* ret =  [succeedResult lj_numberForKey:@"ret"];
        if ([ret isEqualToNumber:@0]) {
            //成功
            @strongify(self)
            NSNumber* maxId = nil;;
            [self appendMessages:[self generateMessage:[succeedResult lj_arrayForKey:@"data"]reverse:YES maxId:&maxId]];
            if (maxId) {
                self.maxMessageId = maxId;
            }
            
        }
        else
        {
            NSLog(@"没有轮询到信息!");
        }
    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
        
    }];
}

- (void) startLoop{
    
    NSLog(@"开始轮询...");
    if (nil !=self.timer && [self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(fireTimer:) userInfo:nil repeats:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (CURRENT_SYS_VERSION >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
    }
    self.title = NSLocalizedStringFromTable(@"Chat", @"MessageDisplayKitString", @"聊天");
    
    
    
    // Custom UI
    //    [self setBackgroundColor:[UIColor clearColor]];
    //    [self setBackgroundImage:[UIImage imageNamed:@"TableViewBackgroundImage"]];
    
    // 设置自身用户名
    //self.messageSender = @"Jack";
    
    // 添加第三方接入数据
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    //NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video", @"sharemore_location", @"sharemore_friendcard", @"sharemore_myfav", @"sharemore_wxtalk", @"sharemore_videovoip", @"sharemore_voiceinput", @"sharemore_openapi", @"sharemore_openapi", @"avatar"];
    //NSArray *plugTitle = @[@"照片", @"拍摄", @"位置", @"名片", @"我的收藏", @"实时对讲机", @"视频聊天", @"语音输入", @"大众点评", @"应用", @"曾宪华"];
    NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video"];
    NSArray *plugTitle = @[@"照片", @"拍摄"];
    for (NSString *plugIcon in plugIcons) {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
    }
    
//    NSMutableArray *emotionManagers = [NSMutableArray array];
//    for (NSInteger i = 0; i < 10; i ++) {
//        XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
//        emotionManager.emotionName = [NSString stringWithFormat:@"表情%ld", (long)i];
//        NSMutableArray *emotions = [NSMutableArray array];
//        for (NSInteger j = 0; j < 18; j ++) {
//            XHEmotion *emotion = [[XHEmotion alloc] init];
//            NSString *imageName = [NSString stringWithFormat:@"section%ld_emotion%ld", (long)i , (long)j % 16];
//            emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"emotion%ld.gif", (long)j] ofType:@""];
//            emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
//            [emotions addObject:emotion];
//        }
//        emotionManager.emotions = emotions;
//        
//        [emotionManagers addObject:emotionManager];
//    }
//    
//    self.emotionManagers = emotionManagers;
//    [self.emotionManagerView reloadData];
    
    self.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
    
    
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.emotionManagers = nil;
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
}

/*
 [self removeMessageAtIndexPath:indexPath];
 [self insertOldMessages:self.messages];
 */

#pragma mark - XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    UIViewController *disPlayViewController;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypePhoto: {
            DLog(@"message : %@", message.photo);
            DLog(@"message : %@", message.videoConverPhoto);
            XHDisplayMediaViewController *messageDisplayTextView = [[XHDisplayMediaViewController alloc] init];
            messageDisplayTextView.message = message;
            disPlayViewController = messageDisplayTextView;
            break;
        }
            break;
        case XHBubbleMessageMediaTypeVoice: {
            DLog(@"message : %@", message.voicePath);
            
            // Mark the voice as read and hide the red dot.
            message.isRead = YES;
            messageTableViewCell.messageBubbleView.voiceUnreadDotImageView.hidden = YES;
            
            [[XHAudioPlayerHelper shareInstance] setDelegate:(id<NSFileManagerDelegate>)self];
            if (_currentSelectedCell) {
                [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
            }
            if (_currentSelectedCell == messageTableViewCell) {
                [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
                [[XHAudioPlayerHelper shareInstance] stopAudio];
                self.currentSelectedCell = nil;
            } else {
                self.currentSelectedCell = messageTableViewCell;
                [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
                [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voiceUrl toPlay:YES];
            }
            break;
        }
        case XHBubbleMessageMediaTypeEmotion:
            DLog(@"facePath : %@", message.emotionPath);
            break;
        case XHBubbleMessageMediaTypeLocalPosition: {
            DLog(@"facePath : %@", message.localPositionPhoto);
            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init];
            displayLocationViewController.message = message;
            disPlayViewController = displayLocationViewController;
            break;
        }
        default:
            break;
    }
    if (disPlayViewController) {
        UINavigationController* nav = (UINavigationController*)((AppDelegate*)[UIApplication sharedApplication].delegate).window.rootViewController;
        [nav pushViewController:disPlayViewController animated:YES];
    }
}

- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"text : %@", message.text);
    XHDisplayTextViewController *displayTextViewController = [[XHDisplayTextViewController alloc] init];
    displayTextViewController.message = message;
    [self.navigationController pushViewController:displayTextViewController animated:YES];
}

- (void)didSelectedAvatarOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexPath : %@", indexPath);

}

- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType {
    
}

#pragma mark - XHAudioPlayerHelper Delegate

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
    if (!_currentSelectedCell) {
        return;
    }
    [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    self.currentSelectedCell = nil;
}

#pragma mark - XHEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers {
    return self.emotionManagers.count;
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return [self.emotionManagers objectAtIndex:column];
}

- (NSArray *)emotionManagersAtManager {
    return self.emotionManagers;
}

#pragma mark - XHMessageTableViewController Delegate

- (BOOL)shouldLoadMoreMessagesScrollToTop {
    return YES;
}

- (void)loadMoreMessagesScrollTotop {
    @weakify(self)
    if (!self.loadingMoreMessage){
        self.loadingMoreMessage = YES;
    
        
        NSNumber* minId = nil;
        XHMessage* msg = [self.messages lj_safeObjectAtIndex:0];
        if (msg) {
            id obj = [msg lj_valueForKey:@"rawData"];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                minId = [(NSDictionary*)obj lj_numberForKey:@"id"];
            }
        }
        if (nil == minId) {
            self.loadingMoreMessage = NO;
            return;
        }
        
        [HTTP_MANAGER startNormalPostWithParagram:@{@"phone":[[NSUserDefaults standardUserDefaults]objectForKey:@"user"],@"projectId":self.projectId,@"messageId":minId} Commandtype:@"app/message/getHistoryMessage" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
            
            NSNumber* ret =  [succeedResult lj_numberForKey:@"ret"];
            if ([ret isEqualToNumber:@0]) {
                //成功
                @strongify(self)
                NSNumber* maxId = nil;;
                [self insertOldMessages:[self generateMessage:[succeedResult lj_arrayForKey:@"data"]reverse:YES maxId:&maxId]];

            }
            else
            {
                NSLog(@"没有更多");
            }
            self.loadingMoreMessage = NO;
        } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
            
        }];
    }
    
//    if (!self.loadingMoreMessage) {
//        self.loadingMoreMessage = YES;
//        
//        WEAKSELF
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSMutableArray *messages = [weakSelf getStartMessages];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf insertOldMessages:messages];
//                weakSelf.loadingMoreMessage = NO;
//            });
//        });
//    }
}

/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    [HTTP_MANAGER startNormalPostWithParagram:@{@"phone":[[NSUserDefaults standardUserDefaults]objectForKey:@"user"],@"projectId":self.projectId,@"message":text} Commandtype:@"app/message/addMessage" successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        NSLog(@"发送文本成功");
        [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
        NSLog(@"发送文本失败");
    }];
}

/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self sendImageMessage:photo];
}

/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:videoConverPhoto videoPath:videoPath videoUrl:nil sender:sender timestamp:date];
    videoMessage.avatar = [UIImage imageNamed:@"avatar"];
    videoMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/meIcon@2x.png";
    [self addMessage:videoMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVideo];
}

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self sendVoiceMessage:voicePath dur:voiceDuration];
}

/**
 *  发送第三方表情消息的回调方法
 *
 *  @param facePath 目标第三方表情的本地路径
 *  @param sender   发送者的名字
 *  @param date     发送时间
 */
- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *emotionMessage = [[XHMessage alloc] initWithEmotionPath:emotionPath sender:sender timestamp:date];
    emotionMessage.avatar = [UIImage imageNamed:@"avatar"];
    emotionMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/meIcon@2x.png";
    [self addMessage:emotionMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeEmotion];
}

/**
 *  有些网友说需要发送地理位置，这个我暂时放一放
 */
- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *geoLocationsMessage = [[XHMessage alloc] initWithLocalPositionPhoto:geoLocationsPhoto geolocations:geolocations location:location sender:sender timestamp:date];
    geoLocationsMessage.avatar = [UIImage imageNamed:@"avatar"];
    geoLocationsMessage.avatarUrl = @"http://childapp.pailixiu.com/jack/meIcon@2x.png";
    [self addMessage:geoLocationsMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeLocalPosition];
}

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL ret = NO;
    XHMessage* curr = [self.messages lj_safeObjectAtIndex:indexPath.row];
    XHMessage* next = [self.messages lj_safeObjectAtIndex:indexPath.row+1];
    NSDate* dateCurr = curr.timestamp;
    NSDate* dateNext = next.timestamp;
    if (nil == dateCurr) {
        dateCurr = [NSDate date];
    }
    if (nil == dateNext) {
        dateNext = [NSDate date];
    }
    
    NSTimeInterval interval = [dateNext timeIntervalSinceDate:dateCurr];
    if (interval > 5*60) {
        ret = YES;
    }
    
    return ret;
}

/**
 *  配置Cell的样式或者字体
 *
 *  @param cell      目标Cell
 *  @param indexPath 目标Cell所在位置IndexPath
 */
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.avatarButton.layer.cornerRadius = cell.avatarButton.frame.size.height*0.5f;
    cell.avatarButton.layer.masksToBounds = YES;
}

/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

@end

