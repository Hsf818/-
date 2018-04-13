//
//  FGUser.h
//  
//
//  Created by hsf on 2018/4/13.
//

#import <Foundation/Foundation.h>

@interface FGUser : NSObject
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
@end
