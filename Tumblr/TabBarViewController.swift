//
//  TabBarViewController.swift
//  Tumblr
//
//  Created by Kyle Pickering on 10/13/14.
//  Copyright (c) 2014 Kyle Pickering. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var homeTabButton: UIButton!
    @IBOutlet weak var searchTabButton: UIButton!
    @IBOutlet weak var exploreImage: UIImageView!
    
    var homeViewController: HomeViewController!
    var searchViewController: SearchViewController!
    var accountViewController: AccountViewController!
    var trendingViewController: TrendingViewController!
    
    var currentTabButton: UIButton!
    var isPresenting: Bool = true

    var destinationVC: ComposeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        homeViewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as HomeViewController
        searchViewController = storyboard.instantiateViewControllerWithIdentifier("SearchViewController") as SearchViewController
        accountViewController = storyboard.instantiateViewControllerWithIdentifier("AccountViewController") as AccountViewController
        trendingViewController = storyboard.instantiateViewControllerWithIdentifier("TrendingViewController") as TrendingViewController
        
        //onHomeButton(self)
        currentTabButton = homeTabButton
        setTab(homeViewController, tab: homeTabButton)
        
       UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.Repeat | UIViewAnimationOptions.Autoreverse, animations: { () -> Void in
            self.exploreImage.frame.origin.y -= 5
        }) { (finished:Bool) -> Void in
            //code
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHomeButton(sender: UIButton) {
        setTab(homeViewController, tab: sender)
    }

    @IBAction func onSearchButton(sender: UIButton) {
        setTab(searchViewController, tab: sender)
    }
    
    @IBAction func onAccountButton(sender: UIButton) {
        setTab(accountViewController, tab: sender)
    }
    
    @IBAction func onTrendingButton(sender: UIButton) {
        setTab(trendingViewController, tab: sender)
    }
    
    func setTab(controller: UIViewController, tab: UIButton) {
        currentTabButton.selected = false
        currentTabButton = tab
        currentTabButton.selected = true
        
        if tab == searchTabButton {
            exploreImage.hidden = true
        } else {
            exploreImage.hidden = false
        }
        
        self.addChildViewController(controller)
        containerView.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
        
        controller.view.alpha = 0
        println(controller.view.frame.size)
        //controller.view.bounds = containerView.bounds
        println(containerView.frame.size)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            controller.view.alpha = 1
        })
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if segue.identifier == "composeSegue" {
            destinationVC = segue.destinationViewController as ComposeViewController
            destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
            destinationVC.transitioningDelegate = self
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        println("animating transition")
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        if (isPresenting) {
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            
            destinationVC.textButton.frame.origin.y += 3700
            destinationVC.photoButton.frame.origin.y += 600
            destinationVC.quoteButton.frame.origin.y += 3700
            destinationVC.linkButton.frame.origin.y += 4700
            destinationVC.chatButton.frame.origin.y += 600
            destinationVC.videoButton.frame.origin.y += 4700

            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 1.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.destinationVC.textButton.frame.origin.y -= 3700
                self.destinationVC.photoButton.frame.origin.y -= 600
                self.destinationVC.quoteButton.frame.origin.y -= 3700
                self.destinationVC.linkButton.frame.origin.y -= 4700
                self.destinationVC.chatButton.frame.origin.y -= 600
                self.destinationVC.videoButton.frame.origin.y -= 4700
                
                toViewController.view.alpha = 1
                }, completion: { (finished:Bool) -> Void in
                transitionContext.completeTransition(true)
            })
            
        } else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.destinationVC.textButton.frame.origin.y -= 600
                self.destinationVC.photoButton.frame.origin.y -= 3700
                self.destinationVC.quoteButton.frame.origin.y -= 600
                self.destinationVC.linkButton.frame.origin.y -= 3700
                self.destinationVC.chatButton.frame.origin.y -= 4700
                self.destinationVC.videoButton.frame.origin.y -= 3700
                fromViewController.view.alpha = 0
            }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
            }
        }
    }
}
