//
//  WebViewController.swift
//  FoodPin
//
//  Created by Andrey Levchenko on 13.01.15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView:UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = NSURL(string: "http://www.appcoda.com") {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
