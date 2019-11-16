//
//  RestServicies.h
//  Downloading
//
//  Created by ihub on 13/10/18.
//  Copyright © 2018 ecoihub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestServicies : NSObject

+(RestServicies *)getSharedInstance;

-(void)downloadpdfReport:(NSString*)doctorId :(NSString*)fromTime :(NSString*)toTime :(int)clinicalId withCompletionHandler:(void (^)(NSInteger))handler;

@end
