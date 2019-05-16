//
//  ViewController.swift
//  NovaCzPlayer
//
//  Created by Karel Smetana on 06/04/2019.
//  Copyright © 2019 CME Services s.r.o. All rights reserved.
//

import UIKit
import ZappPlugins
import ApplicasterSDK
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
		
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    
    @IBAction func buttonPlay_clicked() {
		//self.presentPlayer()
		
		// tmp show alert, we are not using fullscreen func, we have build one
		// create the alert
		let alert = UIAlertController(title: "Fullscreen mode", message: "We use build fullscreen mode. Please open inline video and tap on fullscreen icon.", preferredStyle: UIAlertController.Style.alert)
		
		// add an action (button)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		
		// show the alert
		self.present(alert, animated: true, completion: nil)
    }
    
    func presentPlayer() {
		let item = createNovaVideo()
        let pluggablePlayer = ZPPlayerManager.sharedInstance.create(playableItem: item)
        pluggablePlayer.presentPlayerFullScreen?(self, configuration: nil) {
            pluggablePlayer.pluggablePlayerPlay(nil)
        }
    }
	
	private func createNovaVideo() -> ZPPlayable {
		let item = Playable()
		item.videoURL = ""
		
		item.fullscreenView = true  // fullscreen video
		
		return item
	}
}

