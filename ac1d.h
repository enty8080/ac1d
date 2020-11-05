#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@interface ac1d : NSObject {
}

@property (retain) UIDevice *thisUIDevice;

-(void)battery;
-(void)vibrate;
-(void)locate;
-(void)say:(NSString *)message;

@end
