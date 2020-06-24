//
//  ConnectionFailViewController.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/26/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit
import Network

class ConnectionFailViewController: UIViewController, StoryboardInstantiable {
static var storyboardName: String = "ConnectionFailViewController"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        UDefaults.connectionFailDisplayed = true
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let pathMonitoring = NWPathMonitor()
        pathMonitoring.pathUpdateHandler = { path in
            if path.status == .satisfied {
                AccountActions.TestAuthentification { (responseType) in
                    if responseType == .Ok || responseType == .Unauthorize {
                        pathMonitoring.cancel()
                        DispatchQueue.main.async {
                            self.dismiss(animated: true) {
                                UDefaults.connectionFailDisplayed = false
                            }
                        }
                    }
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        pathMonitoring.start(queue: queue)
    }
    
    @IBAction func refresh() {
        let indicator = startIndicator()
        let pathMonitoring = NWPathMonitor()
        pathMonitoring.pathUpdateHandler = { path in
            if path.status == .satisfied {
                AccountActions.TestAuthentification { (responseType) in
                    DispatchQueue.main.async {
                        self.stopIndicator(loadingView: indicator)
                        if responseType == .Ok || responseType == .Unauthorize {
                            self.dismiss(animated: true) {
                                UDefaults.connectionFailDisplayed = false
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.stopIndicator(loadingView: indicator)
                }
            }
            pathMonitoring.cancel()
        }
        let queue = DispatchQueue(label: "Monitor")
        pathMonitoring.start(queue: queue)
    }
    
    func startIndicator() -> LoadingView {
        let loadingView = LoadingView.instantiate(size: self.view.frame.size)
        self.view.addSubview(loadingView)
        loadingView.start()
        self.view.isUserInteractionEnabled = false
        return loadingView
    }

    func stopIndicator(loadingView: LoadingView) {
        loadingView.stop {
            loadingView.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        }
    }
}
