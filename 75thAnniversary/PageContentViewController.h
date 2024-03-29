//
//  PageContentViewController.h
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PageContentViewController : UIViewController<AVAudioPlayerDelegate, AVAudioSessionDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) AVAudioPlayer * backgroundMusicPlayer;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property (nonatomic, strong) NSMutableArray *imageFiles;
@end
