//
//  DetailViewController.h
//  Taylorswift
//
//  Created by Ryo Suzuki on 11/30/12.
//  Copyright (c) 2012 Ryo Suzuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SBJson.h"

@interface DetailViewController : UIViewController <AVAudioPlayerDelegate, AVAudioSessionDelegate>
{
    NSURLConnection *connection;
    NSMutableData *data;
    
    IBOutlet UIImageView *image;
}
@property (strong, nonatomic) id detailItem;
@property (nonatomic, retain) NSString *trackId;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) UIImageView *image;
@end
