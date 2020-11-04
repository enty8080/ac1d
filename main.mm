#import <Foundation/Foundation.h>

void alert(NSString *given_title, NSString *given_message) {
    const char *title = [given_title cStringUsingEncoding:NSASCIIStringEncoding];
    const char *message = [given_message cStringUsingEncoding:NSASCIIStringEncoding];
    extern char *optarg;
    extern int optind;

    CFTimeInterval timeout = 0;
    CFMutableDictionaryRef dict = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionaryAddValue( dict, kCFUserNotificationAlertHeaderKey, CFStringCreateWithCString(NULL, title, kCFStringEncodingUTF8) );
    CFDictionaryAddValue( dict, kCFUserNotificationAlertMessageKey, CFStringCreateWithCString(NULL, message, kCFStringEncodingUTF8) );
    SInt32 error;
    CFOptionFlags flags = 0;
    flags |= kCFUserNotificationPlainAlertLevel;
    CFDictionaryAddValue( dict, kCFUserNotificationAlertTopMostKey, kCFBooleanTrue );
    CFNotificationCenterPostNotificationWithOptions( CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("test"),  NULL, NULL, kCFNotificationDeliverImmediately );
    CFUserNotificationCreate( NULL, timeout, flags, &error, dict );
}

int main(int argc, char *argv[])
{
    @autoreleasepool {
        if (argc < 3) {
            printf("Usage: ac1d <option> <arguments>\n");
        } else {
            NSMutableArray *results = [NSMutableArray array];
            for (int i = 0; i < argc; i++) {
                NSString *str = [[NSString alloc] initWithCString:argv[i] encoding:NSUTF8StringEncoding];
                [results addObject:str];
            }
            if ([results[1] isEqualToString:@"alert"]) {
                alert(results[2], results[3]);
            }
        }
    }
    return 0;
}
