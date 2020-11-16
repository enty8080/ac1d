//
//  main.mm
//  ac1d
//
//  Created by Ivan Nikolsky on 2020.
//  Copyright (C) 2020 Ivan Nikolsky. All rights reserved.
//

#import "ac1d.h"

NSArray *commands = [[NSArray alloc] initWithObjects: @"alert", @"battery", @"dial", @"dhome", @"getvol", @"home", @"location", @"player", @"say", @"setvol", @"state", @"openurl", @"openapp", nil];

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        ac1d *ac1d_base = [[ac1d alloc] init];
        if (argc < 2) printf("Usage: ac1d <option>\n");
        else {
            NSMutableArray *args = [NSMutableArray array];
            for (int i = 0; i < argc; i++) {
                NSString *str = [[NSString alloc] initWithCString:argv[i] encoding:NSUTF8StringEncoding];
                [args addObject:str];
            }
            if ([commands containsObject:args[1]]) [ac1d_base send_command:args];
            else printf("Usage: ac1d <option>\n");
        }
    }
    return 0;
}
