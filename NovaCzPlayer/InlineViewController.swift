//
//  InlineViewController.swift
//  NovaCzPlayer
//
//  Created by Karel Smetana on 06/04/2019.
//  Copyright © 2019 CME Services s.r.o. All rights reserved.
//

import Foundation
import ZappPlugins
import ApplicasterSDK
import WebKit

class InlineViewController: UIViewController, WKNavigationDelegate {
	
	@IBOutlet weak var VideoContainerView: UIView!
	var zappPlayer: ZPPlayerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startPlayVideo()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Getting the current player instance and stopping the video player when our view is going to disappear.
        ZPPlayerManager.sharedInstance.lastActiveInstance?.pluggablePlayerStop()
		
		
    }
    
    func startPlayVideo() {
		let item = createNovaVideo()
		let pluggablePlayer = ZPPlayerManager.sharedInstance.create(playableItem: item)
        pluggablePlayer.pluggablePlayerAddInline(self, container: VideoContainerView)
        pluggablePlayer.pluggablePlayerPlay(nil)
		
    }
	
	private func createNovaVideo() -> ZPPlayable {
		let item = Playable()
		item.videoURL = ""
		
		item.fullscreenView = false
		
		return item
	}
}
