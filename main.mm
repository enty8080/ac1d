#import <Foundation/Foundation.h>

void showAlert(NSString args) {
    NSData *jsonData = [args dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *uploadargs = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    const char *title = [[NSString stringWithFormat:@"%@",[uploadargs valueForKey:@"title"]] UTF8String];
    const char *message = [[NSString stringWithFormat:@"%@",[uploadargs valueForKey:@"message"]] UTF8String];

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
    [self term];
}

int main(int argc, const char *argv[])
{
    @autoreleasepool {
        if (argc < 3) {
            print("Usage: ac1d <option> <arguments>\n");
        } else {
            if ([argv[1] isEqualToString:@"alert"]) {
                showAlert(argv[2]);
            }
        }
    }
    return 0;
}
