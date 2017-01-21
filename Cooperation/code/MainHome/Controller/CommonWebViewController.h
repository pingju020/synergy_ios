//
//  CommonWebViewController.h
//  synergy
//
//  Created by Tion on 17/1/15.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonWebViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    UIActivityIndicatorView *activityIndicatorView;
    UIView *opaqueView;
}
@property  (nonatomic, strong) NSString* params;

-(instancetype)initWithUrl:(NSString*)UrlString;

@end
