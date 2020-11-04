#import <Foundation/Foundation.h>
#import "ac1d.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NULL;
    }
    if (argc < 3) printf("Usage: ac1d <option> <arguments>\n");
    else {
        NSMutableArray *args = [NSMutableArray array];
        for (int i = 0; i < argc; i++) {
            NSString *str = [[NSString alloc] initWithCString:argv[i] encoding:NSUTF8StringEncoding];
            [args addObject:str];
        }
        if ([args[1] isEqualToString:@"alert"]) {
            if (argc < 4) printf("Usage: ac1d alert <title> <message>\n");
            else {
                showAlert(args[2], args[3]);
            }
        }
    }
    return 0;
}
