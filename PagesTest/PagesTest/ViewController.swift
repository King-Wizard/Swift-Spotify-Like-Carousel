// The MIT License (MIT)
//
// Copyright (c) 2015 
// King-Wizard
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController: UIPageViewController!
    
    var pageControl: UIPageControl!
    
    let arrayInformationMessages = [(title:"title 1", description:"description for \n title 1"),
                                    (title:"title 2", description:"description for \n title 2"),
                                    (title:"title 3", description:"description for \n title 3"),
                                    (title:"title 4", description:"description for \n title 4")]
    
    var arrayViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Array containing UIViewControllers which are in fact under the hood 
        // downcasted ContentViewControllers.
        self.initArrayViewControllers()
        
        // UIPageViewController initialization and configuration.
        let toolbarHeight: CGFloat = 60.0
        self.initPageViewController(toolbarHeight)
        
        // Retrieving UIPageControl
        self.initPageControl()
    }
    
    // Required UIPageViewControllerDataSource method
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index: Int = (viewController as! ContentViewController).index
        
        if index == self.arrayViewControllers.count - 1 {
            return self.arrayViewControllers[0]
        }
        
        return self.arrayViewControllers[++index]
    }
    
    // Required UIPageViewControllerDataSource method
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index: Int = (viewController as! ContentViewController).index
        
        if index == 0 {
            return self.arrayViewControllers[self.arrayViewControllers.count - 1]
        }
        
        return self.arrayViewControllers[--index]
    }
    
    // Optional UIPageViewControllerDataSource method
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.arrayInformationMessages.count
    }
    
    // Optional UIPageViewControllerDataSource method
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    /*
        Optional UIPageViewControllerDelegate method
    
        Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether
        the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
    */
    func pageViewController(pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [AnyObject],
        transitionCompleted completed: Bool)
    {
        // Turn is either finished or aborted
        if (completed && finished) {
            // let previousViewController = previousViewControllers[0] as ContentViewController
            let currentDisplayedViewController = self.pageViewController!.viewControllers[0] as! ContentViewController
            self.pageControl.currentPage = currentDisplayedViewController.index
        }
    }
    
    private func initArrayViewControllers() {
        for (var i = 0; i < self.arrayInformationMessages.count; i++) {
            let contentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ContentViewControllerID") as! ContentViewController
            contentViewController.index = i
            contentViewController.titleText = self.arrayInformationMessages[i].title
            contentViewController.descriptionText = self.arrayInformationMessages[i].description
            self.arrayViewControllers.append(contentViewController)
        }
    }
    
    private func initPageViewController(let toolbarHeight: CGFloat) {
        //        self.pageViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PagesWidgetID") as! UIPageViewController
        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        if let pageViewController = self.pageViewController {
            let initViewController = self.arrayViewControllers[0] as! ContentViewController
            let vcArray = [initViewController]
            let frame = self.view.frame
            pageViewController.dataSource = self
            pageViewController.delegate = self
            pageViewController.view.frame = CGRectMake(0, 0, frame.width, frame.height - toolbarHeight)
            pageViewController.setViewControllers(vcArray, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
            self.addChildViewController(pageViewController)
            self.view.addSubview(pageViewController.view)
            //  pageViewController.view.clipsToBounds = true
            pageViewController.didMoveToParentViewController(self)
        }
    }
    
    private func initPageControl() {
        let subviews: Array = self.pageViewController.view.subviews
        var pageControl: UIPageControl! = nil
        
        for (var i = 0; i < subviews.count; i++) {
            if (subviews[i] is UIPageControl) {
                pageControl = subviews[i] as! UIPageControl
                break
            }
        }
        
        self.pageControl = pageControl
    }
    
}
