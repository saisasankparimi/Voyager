//
//  SplashController.swift
//  Voyager
//
//  Created by Sai Sasank Parimi on 7/7/15.
//  Copyright (c) 2015 Sasank. All rights reserved.
//

import UIKit

class SplashController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImageView()
        logo.image = UIImage(named: "logo.png")
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width/2
        let screenHeight = screen.size.height/2
        
        logo.frame = CGRect(x: 0, y: 0, width: 88, height: 88)
        logo.center = self.view.center
        self.view.addSubview(logo)
        
        print(screenWidth)
        
        // angles in iOS are measured as radians PI is 180 degrees so PI × 2 is 360 degrees
        let fullRotation = CGFloat(M_PI * 2)
        
        let duration = 2.0
        let delay = 0.0
        let options = UIViewKeyframeAnimationOptions.CalculationModePaced

        UIView.animateKeyframesWithDuration(duration, delay: delay, options: options, animations: {
            
            // note that we've set relativeStartTime and relativeDuration to zero.
            // Because we're using `CalculationModePaced` these values are ignored
            // and iOS figures out values that are needed to create a smooth constant transition
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                logo.transform = CGAffineTransformMakeRotation(1/3 * fullRotation)
            })
            

            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                logo.transform = CGAffineTransformMakeRotation(2/3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                logo.transform = CGAffineTransformMakeRotation(3/3 * fullRotation)
            })
            
            
                 logo.frame = CGRect(x: screenWidth - 17.5 , y: 26, width: 33, height: 33)
            
            
            }, completion: {(Finished) in
                if (Finished){
                
                    var storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    //        var tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabController") as! UITabBarController
                    var navigationController = storyboard.instantiateViewControllerWithIdentifier("NavController") as! UINavigationController
                    //        var intialView = navigationController.topViewController as! ViewController
                    
                    
                    
                    self.presentViewController(navigationController, animated: false, completion: nil)

                
                }
        })
        
  }

    
    
    
    override func viewDidAppear(animated: Bool) {
            }

   
}
