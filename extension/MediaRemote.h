#ifndef MEDIAREMOTE_H_
#define MEDIAREMOTE_H_

#include <CoreFoundation/CoreFoundation.h>

#if __cplusplus
extern "C" {
#endif

    extern CFStringRef kMRMediaRemoteNowPlayingInfoTitle;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoArtist;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoAlbum;

    typedef NS_ENUM(NSInteger, MRCommand) {
        kMRPlay = 0,
        kMRPause = 1,
        kMRNextTrack = 4,
        kMRPreviousTrack = 5,
    };

    Boolean MRMediaRemoteSendCommand(MRCommand command, id userInfo);

#if __cplusplus
}
#endif

#endif /* MEDIAREMOTE_H_ */
