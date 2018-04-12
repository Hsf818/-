//
//  FGTopics.m
//  百思不得姐
//
//  Created by hsf on 2018/3/20.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGTopics.h"
#import "NSDate+Extension.h"
#import "MJExtension.h"

@implementation FGTopics

{
    CGFloat _cellHeight;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"small_image":@"image0",@"middle_image":@"image2",@"large_image":@"image2"};
}

//- (NSString *)create_time{
//    // 日期类格式化
//    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
//    // 设置日期格式（y：年，月：M，日：d，时：H，分：m，秒：s）
//    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    // 帖子的创建时间
//    NSDate *creat = [fmt dateFromString:_create_time];

//    if(creat.isThisYear){ // 今年
//        if(creat.isToday){ // 今天
//            NSDateComponents *cmps = [[NSDate date] deltaFrom:creat];
//            if (cmps.hour > 1){ // 时间差距>=1小时
//                return [NSString stringWithFormat:@"%zd小时前",cmps.hour];
//            }else if (cmps.minute >= 1){ // 时间差距>=1min
//                return [NSString stringWithFormat:@"%zd分钟前",cmps.minute];
//            }else{// 刚刚
//                return @"刚刚";
//            }
//        }else if(creat.isYesterday){ // 昨天
//            fmt.dateFormat = @"昨天 HH:mm:ss";
//            return [fmt stringFromDate:creat];
//        }else{ // 其他
//            fmt.dateFormat = @"MM-dd HH:mm:ss";
//            return [fmt stringFromDate:creat];
//        }
//    }else{ // 非今年
//        return _create_time;
//    }
//}

- (CGFloat)cellHeight{
    if(!_cellHeight){
        // 文字最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * FGMargin, MAXFLOAT);
        
        // 文字的最大高度
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        // 文字的Y值
        _cellHeight = FGTextY + textH + FGMargin;
        
        if (self.type == FGTopicPicture){ // 图片帖子
            // 图片显示出来的宽度
            CGFloat pictureW = maxSize.width;
            // 图片显示出来的高度
            CGFloat pictureH = pictureW * self.height / self.width;
            
            if (pictureH >= FGTopicPictureMaxH){// 大图
                pictureH = FGTopicPictureH;
                self.bigPicture = YES;
            }
            
            // 计算图片的frame
            CGFloat pictureX = FGMargin;
            CGFloat pictureY = FGTextY + textH + FGMargin;
            
            _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            
            _cellHeight += pictureH + FGMargin;
        }else if (self.type == FGTopicVoice){ // 声音帖子
            
            // 计算声音图片的frame
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = voiceW * self.height / self.width;
            CGFloat voiceX = FGMargin;
            CGFloat voiceY = FGTextY + textH + FGMargin;
            
            _voiceF = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            
            _cellHeight += voiceH + FGMargin;
        }
        
        _cellHeight += FGTabbarH + FGMargin;
    }
    
    return _cellHeight;
}

@end
