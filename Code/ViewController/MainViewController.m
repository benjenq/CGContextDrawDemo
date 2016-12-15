//
//  MainViewController.m
//  EmptyProject
//
//  Created by Administrator on 16/2/25.
//  Copyright 2016 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"



@interface MainViewController () {
    IBOutlet UIImageView *_s1Img;
    IBOutlet UIImageView *_s2Img;
    
    IBOutlet UIImageView *_mixImg;
    IBOutlet UISlider *alphaSlider;
    IBOutlet UISlider *ctmSlider;
    IBOutlet UISlider *scaleSlider;
    
    IBOutlet UISlider *rotateSlider;
    
    IBOutlet UILabel *_lbctmVal;

    IBOutlet UILabel *_lbscaleVal;
    IBOutlet UILabel *_lbrotateVal;
}

#if OS_OBJECT_HAVE_OBJC_SUPPORT == 1

@property (nonatomic, strong) dispatch_queue_t mixTwoImageQueue;

#else

@property (nonatomic, assign) dispatch_queue_t mixTwoImageQueue;

#endif

@end
@implementation MainViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    self.mixTwoImageQueue = dispatch_queue_create("mixTwoImageQueue", NULL);
    [_mixImg.layer setBorderWidth:1];
    [_mixImg.layer setBorderColor:[UIColor redColor].CGColor];
    
    [self slideValueChanged:alphaSlider];
    [self rotateValueChanged:rotateSlider];
    
    UIBarButtonItem *rightBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(resetValue)] autorelease];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.title = @"CGContextDrawImage";
    
}

- (void)resetValue{
    alphaSlider.value = 0.0f;
    ctmSlider.value = 0.0f;
    scaleSlider.value = 1.0f;
    
    rotateSlider.value = 0.0f;
    [self slideValueChanged:alphaSlider];
    [self rotateValueChanged:rotateSlider];
    
}


- (IBAction)slideValueChanged:(UISlider *)sender{
    
    _lbctmVal.text = [NSString stringWithFormat:@"%i",(int)(ctmSlider.value * _s1Img.image.size.height)];
    _lbscaleVal.text = [NSString stringWithFormat:@"%.4f",scaleSlider.value];
    
    dispatch_async(self.mixTwoImageQueue, ^{
        UIImage *resultImage = [self mixTwoImage:_s1Img.image secondImage:_s2Img.image
                                           alpha:alphaSlider.value
                                    translateCTM:(int)(ctmSlider.value * _s1Img.image.size.height)
                                        scaleCTM:scaleSlider.value];
        dispatch_async(dispatch_get_main_queue(), ^{
            _mixImg.image = resultImage;
        });
        
    });
    
    
}

- (IBAction)rotateValueChanged:(UISlider *)sender{
    _lbrotateVal.text = [NSString stringWithFormat:@"%.1f",sender.value];
    
    _mixImg.transform = CGAffineTransformMakeRotation(sender.value / 180.0 * M_PI);

}

- (UIImage *)mixTwoImage:(UIImage *)firstImage secondImage:(UIImage *)secondImage
                   alpha:(float)alpha
            translateCTM:(int)ctmHigit
            scaleCTM:(float)ctmScale
{
    //http://stackoverflow.com/questions/506622/cgcontextdrawimage-draws-image-upside-down-when-passed-uiimage-cgimage
    
    UIGraphicsBeginImageContextWithOptions(firstImage.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //座標轉換，這兩行順序不能對調
    CGContextTranslateCTM(context, 0, ctmHigit);
    CGContextScaleCTM(context, 1.0, ctmScale);

    
    
    CGContextDrawImage(context, CGRectMake(0, 0, _s1Img.image.size.width, _s1Img.image.size.height), firstImage.CGImage);
    
    CGContextBeginTransparencyLayer(context, nil);
    CGContextSetAlpha( context, alpha );
    CGContextDrawImage(context, CGRectMake(0, 0, _s1Img.image.size.width, _s1Img.image.size.height), secondImage.CGImage);
    CGContextEndTransparencyLayer(context);
    
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    CGContextScaleCTM(context, 1.0, -1.0);
    
    UIGraphicsEndImageContext();
    
    
    
    
    return img;

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
