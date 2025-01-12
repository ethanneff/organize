import UIKit

class MenuViewController: UIViewController, SettingsDelegate {
  // MARK: - properties
  var sideMenu: SideMenu?
  var leftMenu: UIViewController?
  var rightMenu: UIViewController?
  var mainMenu: UIViewController?
  
  // MARK: - init
  init() {
    leftMenu = SearchViewController()
    rightMenu = SettingViewController()
    mainMenu = ListViewController()
    
    super.init(nibName: nil, bundle: nil)
    initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func initialize() {
    // FIXME: memory leak... need to deinit all
    sideMenu = SideMenu(parent: self, child: mainMenu!, left: leftMenu!, right: rightMenu!)
    sideMenu!.rightWidth = 184
    sideMenu!.leftWidth = 240
    createNavButtons()
    createDelegates()
  }
  
  // MARK: - deinit
  deinit {
    sideMenu = nil
    leftMenu = nil
    rightMenu = nil
    mainMenu = nil
  }
  
  // MARK: - orientation
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    sideMenu?.orientationChange()
  }
  
  // MARK: - create
  private func createNavButtons() {
//    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(leftNavButtonPressed(_:)))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Organize, target: self, action: #selector(rightNavButtonPressed(_:)))
  }
  
  private func createDelegates() {
    if let rightMenu = rightMenu as? SettingViewController {
      rightMenu.delegate = self
    }
  }
  
  // MARK: - buttons
  internal func leftNavButtonPressed(sender: UIBarButtonItem) {
    sideMenu?.toggle(side: .Left)
    Util.playSound(systemSound: .Tap)
  }
  
  internal func rightNavButtonPressed(sender: UIBarButtonItem) {
    sideMenu?.toggle(side: .Right)
    Util.playSound(systemSound: .Tap)
  }
  
  func settingsButtonPressed(button button: SettingViewController.Button) {
    sideMenu?.toggle(side: .Right)
    if let mainMenu = mainMenu as? SettingsDelegate {
      mainMenu.settingsButtonPressed(button: button)
    }
  }
}