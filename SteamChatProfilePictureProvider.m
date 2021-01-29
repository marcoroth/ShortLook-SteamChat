#import "SteamChatProfilePictureProvider.h"

@implementation SteamChatProfilePictureProvider
  - (DDNotificationContactPhotoPromiseOffer *)contactPhotoPromiseOfferForNotification:(DDUserNotification *)notification {
    NSDictionary *payload = [notification applicationUserInfo];
    NSString *steamId = [NSString stringWithFormat:@"%@", payload[@"steamid"]];
    if (!steamId) return nil;

    // Credit: JeffResc/ShortLook-Steam
    // https://github.com/JeffResc/ShortLook-Steam/blob/64b0d016156085c3f9191c57f42e1874bd6a76c6/SteamContactPhotoProvider.m#L10
    NSURL *profileURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://steamcommunity.com/profiles/%@?xml=1",steamId]];
    NSData *data = [NSData dataWithContentsOfURL: profileURL];
    if (!data) return nil;

    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!dataStr || ![dataStr containsString:@"avatar"]) return nil;
    NSString *imageURLStr = [[[[dataStr componentsSeparatedByString:@"<avatarFull><![CDATA["] objectAtIndex:1] componentsSeparatedByString:@"]]></avatarFull>"] objectAtIndex:0];

    if (imageURLStr) {
      NSURL *imageURL = [NSURL URLWithString:imageURLStr];
      return [NSClassFromString(@"DDNotificationContactPhotoPromiseOffer") offerDownloadingPromiseWithPhotoIdentifier:imageURLStr fromURL:imageURL];
    }
    return nil;
  }
@end
