#import "ShortLook-API.h"

@interface SteamChatProfilePictureProvider : NSObject <DDNotificationContactPhotoProviding>
- (DDNotificationContactPhotoPromiseOffer *)contactPhotoPromiseOfferForNotification:(DDUserNotification *)notification;
@end
