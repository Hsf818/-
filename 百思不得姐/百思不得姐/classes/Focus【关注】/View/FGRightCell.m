//
//  FGRightCell.m
//  百思不得姐
//
//  Created by hsf on 18/1/19.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGRightCell.h"
#import "FGRightModel.h"
#import "UIImageView+WebCache.h"
@interface FGRightCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *subTitleText;

@end
@implementation FGRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRight:(FGRightModel *)right{
    _right = right;
    
    self.titleLable.text = _right.screen_name;
    self.subTitleText.text = [NSString stringWithFormat:@"%@人关注",right.fans_count];
    
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:right.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}
@end
