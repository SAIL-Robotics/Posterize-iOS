//
//  PosterController.m
//  ImageCropView
//
//  Created by Arjun Santhanam on 7/30/15.
//
//

#import "PosterController.h"
@interface PosterController ()

@end
@implementation PosterController

-(void)viewDidLoad {
    NSLog(@"Here!");
    [super viewDidLoad];
    [_posterView setImage:_image];
    
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    CGSize size = [_posterView.image size];
    int totalA4Width = (int) _totalA4Width;
    int totalA4Height = (int)_totalA4Height;
    [self drawCutLine:size :totalA4Width :totalA4Height];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) drawCutLine:(CGSize) size: (NSInteger) totalA4Width : (NSInteger) totalA4Height {
    UIGraphicsBeginImageContext(_posterView.image.size);
    
    
    // Pass 1: Draw the original image as the background
    [_posterView.image drawAtPoint:CGPointMake(0,0)];
    
    // Pass 2: Draw the line on top of original image
   
    
    NSLog(@" totak width %ld and h %ld",(long)totalA4Width,(long)totalA4Height);
    
    double loopWidth = size.width / totalA4Width;
    double loopHeight = size.height / totalA4Height;
    
    NSLog(@" loop width %f and h %f",loopWidth,loopHeight);
    
    
    //Log.e("CutImage", "Loop - " + loopWidth + " " + loopHeight);
    
    
    int xStart = 0, yStart = 0, xEnd = size.width, yEnd = size.height;
    bool isPartWidth = false;
    bool isPartHeight = false;
    
    // set drawing colour
    
    
    for(int i=1; i <= (int) totalA4Width; i++)
    {
        
        xStart = (int)(i * (int)(loopWidth));
        
        NSLog(@"xstart %d",xStart);
        
        // draw a line onto the canvas
        // canvas.drawLine(xStart, 0, xStart, yEnd, p);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 3);
        CGContextMoveToPoint(context, xStart, 0);
        CGContextAddLineToPoint(context, xStart,yEnd);
        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
        CGContextStrokePath(context);
    }
    
    for(int j = 1; j <= (int) totalA4Height; j++)
    {
        
        yStart = (int)(j * (int)(loopHeight));
        
        NSLog(@"ystart %d",yStart);
        // draw a line onto the canvas
        // canvas.drawLine(0, yStart, xEnd, yStart, p);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 3);
        CGContextMoveToPoint(context, 0, yStart);
        CGContextAddLineToPoint(context, xEnd,yStart);
        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
        CGContextStrokePath(context);
        
    }
    
    
    
    
    
    
    
    // Create new image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Tidy up
    UIGraphicsEndImageContext();
    [_posterView setImage:newImage];
    
}

- (IBAction)optimizeButtonClick:(id)sender {
    CGSize size = _posterView.image.size;
    double oldWidth = size.width;
    double oldHeight = size.height;
    double a4Height = 11;
    double a4Width = 8.27;
    double totalA4Width = _newWidth / a4Width;
    double totalA4Height = _newHeight / a4Height;
    
    int totalPapers = (int)(ceil(totalA4Width) * ceil(totalA4Height));    
    int newTotalPapers;
    
   // Log.e("CutImage", totalA4Width +" "+ totalA4Height + " " + totalPapers);
    
    double diffWidth = totalA4Width - (int)totalA4Width;
    double diffHeight = totalA4Height - (int)totalA4Height;
    
    if(diffHeight == 0)
    {
        //Log.e("CutImage", "no height change");
    }
    else if(diffHeight > 0.5)
    {
        //Log.e("CutImage", "No change in height");
    }
    else
    {
        // Log.e("CutImage", "height decrease");
        totalA4Height = floor(totalA4Height) - 0.001;
    }
    
    if(diffWidth == 0)
    {
        //Log.e("CutImage", "no width change");
    }
    else if(diffWidth > 0.5)
    {
        //Log.e("CutImage", "No change in weight");
    }
    else
    {
        //Log.e("CutImage", "width decrease");
        totalA4Width = floor(totalA4Width) - 0.001;
    }
    
    newTotalPapers = (int)(ceil(totalA4Width) * ceil(totalA4Height));
    
    //Log.e("CutImage", totalA4Width +" "+ totalA4Height + " " + newTotalPapers);
    
    if(totalPapers == newTotalPapers)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Optimization"
                                                        message:@"Good to go, optimization not required!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
      
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Optimization"
                                                        message:@"Optimized"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        //Toast.makeText(getApplication(), "You just saved "+ (totalPapers - newTotalPapers) + " papers", Toast.LENGTH_SHORT).show();
    }
    
    
    //_totalA4Width = totalA4Width ;
    //_totalA4Height = totalA4Height;
   // Log.e("CutImage", totalA4Width +" "+ totalA4Height);
    //afterOptimize.setText(totalA4Width + "  " + totalA4Height);
   [self drawCutLine:size :totalA4Width :totalA4Height];
}
@end
