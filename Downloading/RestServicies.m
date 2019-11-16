//
//  RestServicies.m
//  Downloading
//
//  Created by ihub on 13/10/18.
//  Copyright © 2018 ecoihub. All rights reserved.
//

#import "RestServicies.h"

#define IMIHLRestPathName @"http://183.82.109.67:8080/clinical_module/rest"

static RestServicies *sharedRestInstance = nil;
@implementation RestServicies;

+(RestServicies *)getSharedInstance{
    if (!sharedRestInstance) {
        sharedRestInstance = [[super allocWithZone:NULL]init];
        
    }
    return sharedRestInstance;
}

-(void)downloadpdfReport:(NSString*)doctorId :(NSString*)fromTime :(NSString*)toTime :(int)clinicalId withCompletionHandler:(void (^)(NSInteger))handler{
    
    NSString *doctorID = doctorId;
    
    NSString *postdata = [NSString stringWithFormat:@"{\"doctorId\":\"%@\",\"from\":\"%@\",\"to\":\"%@\",\"clinicalId\":%i}",doctorId,fromTime,toTime,clinicalId];
    
    [self downloadTaskBlock:[NSString stringWithFormat:@"%@/expenses/getexpensespdf",IMIHLRestPathName] parameters:postdata :doctorID withCompletionHandler:^(NSInteger response) {
                        handler(response);
                    }];
}

-(void)downloadTaskBlock:(NSString*)url_str parameters:(NSString*)parameter :(NSString*)doctorID withCompletionHandler:(void (^)(NSInteger))handler{
    
    NSFileManager *filemanagerObj = [NSFileManager defaultManager];
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSURL *url = [NSURL URLWithString:url_str];
    NSLog(@"UrlString2:%@",url_str);
    NSLog(@"parameters2:%@",parameter);
            
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
            
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
            
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString*filepath = nil;
    
    filepath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"report%@.pdf",doctorID]] ;
    
    NSString * params =parameter;
    [request setHTTPMethod:@"POST"];
            
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",@"rest",@"rest"];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
            
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/pdf" forHTTPHeaderField:@"Accept"];;
            
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    if ([filemanagerObj fileExistsAtPath:filepath]) {
        NSLog(@"File already Exist");
        NSLog(@"filepath in service:%@",filepath);
        filemanagerObj = nil;
        handler(200);
    }else{
    
    NSURLSessionDownloadTask *downloadTask = [defaultSession downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *err = nil;
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        NSLog(@"statuscode:%ld",(long)httpResp.statusCode);
        if (error==nil) {
            if (httpResp.statusCode == 200) {
                
                NSLog(@"LOcation File:%@",location);
                if ([filemanagerObj createFileAtPath:filepath contents:[NSData dataWithContentsOfURL:location] attributes:nil])
                {
                    NSLog(@"File is saved to =%@",docsDir);
                    handler(httpResp.statusCode);
                    
                }
                else
                {
                    NSLog(@"failed to move: %@",[err userInfo]);
                }
            }else if(httpResp.statusCode >=201 && httpResp.statusCode<=299){
                
            }else if(httpResp.statusCode >=300 && httpResp.statusCode<=399){
                
            }else if(httpResp.statusCode >=400 && httpResp.statusCode<=500){
                
            }
        }
        handler(httpResp.statusCode);
    }];
    
    [downloadTask resume];
    }
}

@end
