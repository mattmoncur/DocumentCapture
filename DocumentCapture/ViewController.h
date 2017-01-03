//
//  ViewController.h
//  DocumentCapture
//
//  Created by Matt Moncur on 2016-12-31.
//  Copyright © 2016 Matt Moncur. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import "GPUImage.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet GPUImageView *videoPreviewView;

@end

