//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 25/8/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var dialogView:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Apply blurring effect
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)

        // Scale down the dialog view
//        dialogView.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        // Move the view off the screen
//        dialogView.transform = CGAffineTransformMakeTranslation(0, 500)
        
        // Combining scale and translate transforms
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        dialogView.transform = CGAffineTransformConcat(scale, translate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        /*
        UIView.animateWithDuration(0.7, delay: 0.0, options: nil, animations: {

            self.dialogView.transform = CGAffineTransformMakeScale(1, 1)
        
        }, completion: nil)
        */
        
        // Spring animation
        /*
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: nil, animations: {

            self.dialogView.transform = CGAffineTransformMakeScale(1, 1)
            self.dialogView.transform = CGAffineTransformMakeTranslation(0, 0)
            
        }, completion: nil)
        */
        
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.dialogView.transform = CGAffineTransformConcat(scale, translate)
            
        }, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
