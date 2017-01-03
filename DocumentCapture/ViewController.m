//
//  ViewController.m
//  DocumentCapture
//
//  Created by Matt Moncur on 2016-12-31.
//  Copyright © 2016 Matt Moncur. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () {
    GPUImageVideoCamera *videoCamera;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHoughGPUCameraForLiveStream];
//    [self setupHarrisGPUCameraForLiveStream];
}

-(void)setupHoughGPUCameraForLiveStream {
    //Initialize Video Camera
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    //Create Hough Line Detector
    GPUImageHoughTransformLineDetector *houghLineDetector = [[GPUImageHoughTransformLineDetector alloc] init];
    [houghLineDetector setLineDetectionThreshold:0.30];
    
    //Create Line Generator
    GPUImageLineGenerator *lineGenerator = [[GPUImageLineGenerator alloc] init];
    [lineGenerator forceProcessingAtSize:CGSizeMake(480.0, 640.0)];
    [lineGenerator setLineColorRed:0.0 green:1.0 blue:0.0];
    
    //Render from lines detected in Hough Detector
    [houghLineDetector setLinesDetectedBlock:^(GLfloat* lineArray, NSUInteger linesDetected, CMTime frameTime){
        [lineGenerator renderLinesFromArray:lineArray count:linesDetected frameTime:frameTime];
    }];
    //Create a Gamma Filter
    GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
    //Create a Alpha Blend Filter
    GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    [blendFilter forceProcessingAtSize:CGSizeMake(480.0, 640.0)];
    
    //Add Filters in proper order
    [videoCamera addTarget:houghLineDetector];
    videoCamera.runBenchmark = YES;
    [videoCamera addTarget:gammaFilter];
    [gammaFilter addTarget:blendFilter];
    [lineGenerator addTarget:blendFilter];
    [blendFilter addTarget:self.videoPreviewView];
    
    //Start Capturing Video
    [videoCamera startCameraCapture];
}

-(void)setupHarrisGPUCameraForLiveStream {
    //Initialize Video Camera
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    //Create Harris Line Detector
    GPUImageHarrisCornerDetectionFilter *cornerDetector = [[GPUImageHarrisCornerDetectionFilter alloc] init];
    [cornerDetector setThreshold:0.2];
    //Create Cross Hair Generator
    GPUImageCrosshairGenerator *crosshairGenerator = [[GPUImageCrosshairGenerator alloc] init];
    crosshairGenerator.crosshairWidth = 15.0;
    [crosshairGenerator forceProcessingAtSize:CGSizeMake(480.0, 640.0)];
    [cornerDetector setCornersDetectedBlock:^(GLfloat* cornerArray, NSUInteger cornersDetected, CMTime frameTime) {
        [crosshairGenerator renderCrosshairsFromArray:cornerArray count:cornersDetected frameTime:frameTime];
    }];
    //Create a Gamma Filter
    GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
    //Create a Alpha Blend Filter
    GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    [blendFilter forceProcessingAtSize:CGSizeMake(480.0, 640.0)];
    
    //Add Filters in proper order
    [videoCamera addTarget:cornerDetector];
    videoCamera.runBenchmark = YES;
    [videoCamera addTarget:gammaFilter];
    [gammaFilter addTarget:blendFilter];
    [crosshairGenerator addTarget:blendFilter];
    [blendFilter addTarget:self.videoPreviewView];
    
    //Start Capturing Video
    [videoCamera startCameraCapture];
}


@end
