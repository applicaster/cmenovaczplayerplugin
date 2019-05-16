//
//  VideoPlayerViewController.swift
//  NovaCzPlayer
//
//  Created by Karel Smetana on 11/04/2019.
//  Copyright © 2019 CME Services s.r.o. All rights reserved.
//

import Foundation
import ZappPlugins
import ApplicasterSDK
import WebKit

// struct for api videoplayer json
struct VideoObj {
	var player = String()
	init(json: [String: Any]) {
		player = json["player"] as? String ?? ""
	}
}

class VideoPlayerViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
	var restWeb: WKWebView?
	var videoPlayer: String?
	var novaPlayerUrl: String?
	
	// MARK: - Lifecycle
	required init(novaPlayerUrl: String) {
		self.novaPlayerUrl = novaPlayerUrl
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Create our preferences on how the web page should be loaded
		let preferences = WKPreferences()
		preferences.javaScriptEnabled = true
		
		// Create a configuration for our preferences
		let configuration = WKWebViewConfiguration()
		configuration.preferences = preferences
		configuration.allowsInlineMediaPlayback = true
		if #available(iOS 10.0, *) {
			configuration.mediaTypesRequiringUserActionForPlayback = .audio
		} else {
			// Fallback on earlier versions
			print("iOS version < 10.0 - can not start automatically play")
		}
		
		// Now instantiate the web view
		restWeb = WKWebView(frame: self.view.bounds, configuration: configuration)
		
		restWeb?.navigationDelegate = self;
		restWeb?.scrollView.isScrollEnabled = false;
		restWeb?.autoresizingMask = [.flexibleWidth, .flexibleHeight]  // new added for fit into parent view
		restWeb?.frame = CGRect(origin: CGPoint.zero, size: self.view.frame.size)  // new added for resizing when rotate
		
		// set player url
		let videoPlayerUrl = self.novaPlayerUrl!
		
		// get data from api
		let apiStringCode = getPlayerCodeFromApi(playerUrl: videoPlayerUrl)
		do {
			let jsonData = apiStringCode.data(using: .utf8)!
			
			//here dataResponse received from a network request
			let jsonResponse = try JSONSerialization.jsonObject(with:
				jsonData, options: [])
			let videoObj = VideoObj(json: jsonResponse as! [String : Any])  // convert data from api to object
			
			// create html string for webview - add missing html
			let videoPlayer = "<html><head><style>body { margin: 0; font-family: sans-serif; background-color: #000000;}</style><script>window.applicasterPlayer = true</script></head><body>\(videoObj.player)</body></html>"
			
			if let theWebView = self.restWeb {
				theWebView.loadHTMLString(videoPlayer, baseURL: nil)
				theWebView.allowsBackForwardNavigationGestures = true
				theWebView.navigationDelegate = self
				theWebView.uiDelegate = self
				theWebView.accessibilityActivate()
				theWebView.isOpaque = false
				self.view.addSubview(theWebView)
			}
		
		} catch let parsingError {
			print("Error", parsingError)
		}
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		//restWeb?.removeFromSuperview()  // didnt work
		restWeb?.loadHTMLString("", baseURL: nil)
		// empty cache
		clearWkWebviewCache()
	}
	
	// MARK: Function for getting data from API by video_url passed from app to plugin
	func getPlayerCodeFromApi(playerUrl: String) -> String {
		let url = URL(string: playerUrl)
		let semaphore = DispatchSemaphore(value: 0)
		
		var result: String = ""
		let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
			if data != nil {
				result = String(data: data!, encoding: String.Encoding.utf8)!
				semaphore.signal()
			} else {
				print("sendRequest error: \(String(describing: error))")
			}
		}
		
		task.resume()
		semaphore.wait()
		return result
	}
	
	// MARK: func for removing data from cache
	func clearWkWebviewCache() {
		URLCache.shared.removeAllCachedResponses()
		
		HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
		print("[WebCacheCleaner] All cookies deleted")
		
		WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
			records.forEach { record in
				WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
				print("[WebCacheCleaner] Record \(record) deleted")
			}
		}
		UserDefaults.standard.synchronize()
	}
}
