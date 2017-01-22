//
//  KnowledgeMainViewController.h
//  Cooperation
//
//  Created by yangjuanping on 2017/1/20.
//  Copyright © 2017年 yangjuanping. All rights reserved.
//

#import "BaseSubVcForMainTab.h"

@interface KnowledgeMainViewController : BaseSubVcForMainTab
{
    IBOutlet UIWebView *webView;
    UIActivityIndicatorView *activityIndicatorView;
    UIView *opaqueView;
}
@end
