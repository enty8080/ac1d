#import "ac1d.h"

@implementation ac1d

-(id)init {
    _thisUIDevice = [UIDevice currentDevice];
    [_thisUIDevice setBatteryMonitoringEnabled:YES];
    _messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.ac1d"];
    return self;
}

-(void)battery {
    int battery_level = ([_thisUIDevice batteryLevel] * 100);
    printf("%d", battery_level);
}

-(void)locate {
    CLLocationManager* manager = [[CLLocationManager alloc] init];
    [manager startUpdatingLocation];
    CLLocation *location = [manager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    NSString *result = [NSString stringWithFormat:@"Latitude: %f\nLongitude: %f\nhttp://maps.google.com/maps?q=%f,%f", coordinate.latitude, coordinate.longitude, coordinate.latitude, coordinate.longitude];
    if ((int)(coordinate.latitude + coordinate.longitude) == 0) {
        result = @"error";
    }
    [manager release];
    printf("%s", [result cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)getvol {
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew context:nil];
    NSString *result = [NSString stringWithFormat:@"%.2f",[AVAudioSession sharedInstance].outputVolume];
    printf("%s", [result cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)openurl:(NSString *)url {
    if (![url isEqualToString:@""]) {
        CFURLRef cu = CFURLCreateWithBytes(NULL, (UInt8*)[url UTF8String], strlen([url UTF8String]), kCFStringEncodingUTF8, NULL);
        if (!cu) printf("error");
        else {
            bool ret = SBSOpenSensitiveURLAndUnlock(cu, 1);
            if (!ret) {
                printf("error");
            }
        }
    }
}

-(void)openapp:(NSString *)application {
    CFStringRef identifier = CFStringCreateWithCString(kCFAllocatorDefault, [application UTF8String], kCFStringEncodingUTF8);
    assert(identifier != NULL);
    int ret = SBSLaunchApplicationWithIdentifier(identifier, FALSE);
    if (ret != 0) {
        printf("error");
    }
    CFRelease(identifier);
}

-(void)send_command:(NSString *)command :(NSString *)arg1 :(NSString *)arg2 {
    NSArray *keys = [NSArray arrayWithObjects:@"cmd", @"arg1", @"arg2", nil];
    NSArray *values = [NSArray arrayWithObjects:command, arg1, arg2, nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    NSDictionary *reply = [_messagingCenter sendMessageAndReceiveReplyName:@"recieve_command" userInfo:userInfo];
    NSString *replystr = [reply objectForKey:@"returnStatus"];
    printf("%s", [replystr cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
