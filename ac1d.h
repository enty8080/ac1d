//
//  main.mm
//  ac1d
//
//  Created by Ivan Nikolsky on 2020.
//  Copyright (C) 2020 Ivan Nikolsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>

@interface ac1d : NSObject {
}

@property (retain) CPDistributedMessagingCenter *messagingCenter;

-(void)send_command:(NSMutableArray *)args;

@end
