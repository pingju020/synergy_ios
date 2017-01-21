//
//  LibraryWebViewController.h
//  synergy
//
//  Created by Tion on 17/1/12.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryWebViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    UIActivityIndicatorView *activityIndicatorView;
    UIView *opaqueView;
}
@property  (nonatomic, strong) NSString* params;
@end
