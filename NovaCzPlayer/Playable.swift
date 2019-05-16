//
//  Playable.swift
//  NovaCzPlayer
//
//  Created by Karel Smetana on 21/04/2019.
//  Copyright © 2019 CME Services s.r.o. All rights reserved.
//

import Foundation
import ZappPlugins

class Playable: NSObject, ZPPlayable {
	
	public var name = ""
	public var playDescription = ""
	public var videoURL = ""
	public var overlayURL = ""
	public var live = false
	public var free = true
	public var publicPageURL = ""
	public var fullscreenView = false
	
	func playableName() -> String! {
		return name
	}
	
	func playableDescription() -> String! {
		return playDescription
	}
	
	func contentVideoURLPath() -> String! {
		return videoURL
	}
	
	func overlayURLPath() -> String! {
		return overlayURL
	}
	
	func isLive() -> Bool {
		return live
	}
	
	func isFree() -> Bool {
		return free
	}
	
	func publicPageURLPath() -> String! {
		return publicPageURL
	}
	
	func analyticsParams() -> [AnyHashable : Any]! {
		return [:]
	}
	
	func isFulscreenView() -> Bool {
		return fullscreenView
	}
	
	var identifier: NSString?
	
	var extensionsDictionary: NSDictionary?
}

