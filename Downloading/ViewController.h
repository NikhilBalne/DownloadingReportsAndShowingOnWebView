//
//  ViewController.h
//  Downloading
//
//  Created by ihub on 13/10/18.
//  Copyright © 2018 ecoihub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestServicies.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *reportPdfInWebview;
@property (strong,nonatomic) NSString*path_str;
@property (strong,nonatomic) NSURL*urlstr;

@end

