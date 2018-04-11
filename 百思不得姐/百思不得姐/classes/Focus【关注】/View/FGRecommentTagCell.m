//
//  FGRecommentTagCell.m
//  百思不得姐
//
//  Created by hsf on 18/1/19.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGRecommentTagCell.h"
#import "FGRecommentModel.h"

@interface FGRecommentTagCell()
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;


@end
@implementation FGRecommentTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = FGColor(244, 244, 244);
//    self.textLabel.textColor = FGColor(78, 78, 78);

}

-(void)setCategory:(FGRecommentModel *)category{
    _category = category;
    
    self.textLabel.text = category.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected ? self.selectedIndicator.backgroundColor : FGColor(78, 78, 78);
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 重新调整内部textLabel的frame
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
}

@end
