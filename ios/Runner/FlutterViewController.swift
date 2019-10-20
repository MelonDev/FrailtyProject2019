let kOverlayStyleUpdateNotificationName = "io.flutter.plugin.platform.SystemChromeOverlayNotificationName"
let kOverlayStyleUpdateNotificationKey = "io.flutter.plugin.platform.SystemChromeOverlayNotificationKey"

extension FlutterViewController {
    private struct StatusBarStyleHolder {
        static var style: UIStatusBarStyle = .default
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appStatusBar(notification:)),
            name: NSNotification.Name(kOverlayStyleUpdateNotificationName),
            object: nil
        )
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return StatusBarStyleHolder.style
    }
    
    @objc private func appStatusBar(notification: NSNotification) {
        guard
            let info = notification.userInfo as? Dictionary<String, Any>,
            let statusBarStyleKey = info[kOverlayStyleUpdateNotificationKey] as? Int
        else {
            return
        }
        
        if #available(iOS 13.0, *) {
            StatusBarStyleHolder.style = statusBarStyleKey == 0 ? .darkContent : .lightContent
        } else {
            StatusBarStyleHolder.style = statusBarStyleKey == 0 ? .default : .lightContent
        }
        
        setNeedsStatusBarAppearanceUpdate()
    }
}
