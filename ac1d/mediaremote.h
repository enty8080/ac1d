#ifndef MEDIAREMOTE_H_
#define MEDIAREMOTE_H_

#if __cplusplus
extern "C" {
#endif
    
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
