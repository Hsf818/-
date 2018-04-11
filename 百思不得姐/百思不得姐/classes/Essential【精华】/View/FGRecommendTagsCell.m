//
//  FGRecommendTagsCell.m
//  百思不得姐
//
//  Created by hsf on 2018/3/18.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGRecommendTagsCell.h"
#import "UIImageView+WebCache.h"
#import "FGRecommendModel.h"

@interface FGRecommendTagsCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageListImageview;
@property (weak, nonatomic) IBOutlet UILabel *themeLable;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@end
@implementation FGRecommendTagsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRecommends:(FGRecommendModel *)recommends{
    _recommends = recommends;
    
    [self.imageListImageview sd_setImageWithURL:[NSURL URLWithString:recommends.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    [self.themeLable setText:recommends.theme_name];
    
    NSString *subNumber = nil;
    if ([recommends.sub_number integerValue] < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人订阅", recommends.sub_number];
    } else { // 大于等于10000
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅", [recommends.sub_number integerValue] / 10000.0];
    }
    self.subTitle.text = subNumber;
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.x = 10;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 3;
    
    [super setFrame:frame];
}


@end
