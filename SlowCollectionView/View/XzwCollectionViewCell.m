//
//  XzwCollectionViewCell.m
//  SlowCollectionView
//
//  Created by Vilson on 16/5/11.
//  Copyright © 2016年 demo. All rights reserved.
//

#import "XzwCollectionViewCell.h"
#define cellRowHeight  IPHONE6WH(85)
#define cellRowWith   IPHONE6WH(63.5)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define IPHONE6WH(x) (([UIScreen mainScreen].bounds.size.width/375.0)*(x))
#define StringObj(objString) [NSString stringWithFormat:@"%@",objString]
@interface XzwCollectionViewCell ()
@end
@implementation XzwCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imgView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
        //self.imgView.center = CGPointMake(frame.size.width/2, frame.size.height- IPHONE6WH(63.5)*0.5);
        self.imgView.clipsToBounds = YES;
        self.imgView.image = [UIImage imageNamed:@"Untitled8.jpg"];
        self.imgView.layer.masksToBounds = YES;
        self.imgView.layer.cornerRadius =  self.contentView.bounds.size.height/2;
        [self.contentView addSubview:self.imgView];
    }
    return self;
}

@end

