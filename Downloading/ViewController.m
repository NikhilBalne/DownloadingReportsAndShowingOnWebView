//
//  ViewController.m
//  Downloading
//
//  Created by ihub on 13/10/18.
//  Copyright © 2018 ecoihub. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

{
    NSString *doctorId;
    NSString *fromDate;
    NSString *toDate;
    int clinicId;
    NSString *url_str;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    doctorId = @"DR39";
    fromDate = @"09-09-2018";
    toDate = @"09-10-2018";
    clinicId = 369;
 
    [self callDownload];
    
}

-(void)callDownload{
    
    RestServicies *restlogin = [RestServicies getSharedInstance];
    
    [restlogin downloadpdfReport:doctorId :fromDate :toDate :clinicId withCompletionHandler:^(NSInteger response) {
        
        if (response == 200) {
            NSLog(@"Result 200");
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"report%@.pdf",doctorId]];
            
            NSLog(@"pathname:%@",filePath);
            self.path_str = filePath;
            
            if ([fileManager fileExistsAtPath:filePath]) {
                
                //NSLog(@"file exist");
                self.urlstr = [NSURL fileURLWithPath:filePath];
                NSMutableURLRequest*urlrequest = [[NSMutableURLRequest alloc]initWithURL:self.urlstr];
                [self.reportPdfInWebview loadRequest:urlrequest];
            }else{
                NSLog(@"Report is not Available");
                
            }
            
        }else if(response >= 201 && response < 300){
            NSLog(@"Result 200>");

        }
        else if(response >= 400 && response < 500){
            NSLog(@"Result 400>");
            
        }else if(response >= 500 && response < 600){
            NSLog(@"Result 500>");

        }
    }];
}

@end
