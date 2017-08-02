import Cocoa


protocol TabStripControllerDelegate
{
  func tabActivated() // contents
  func tabChanged() // change: TabStripModelObserver.TabChangeType, contents
  func tabDetached() // contents
}

class TabStripController: NSViewController
{
  var tabStripView: TabStripView
  weak var switchView: NSView?
  var dragBlockingView: NSView?
  var newTabButton: NewTabButton? { return tabStripView.newTabButton }
  var dragController: TabStripController!
  // newTabTrackingArea: tracking area
  // bridge: model observer bridge
  var model: TabStripModel!
  var delegate: TabStripControllerDelegate?
  // newTabButtonShowingHoverImage
  // tabContentsArray: [TabContentsController]
  // tabArray: [TabController]
  // closingControllers: [TabController]
  
  var placeholderTab: TabView?
  var placeholderFrame: NSRect?
  var droppedTabFrame: NSRect?
  // targetFrames: [NSView: NSRect]
  var newTabTargetFrame: NSRect?
  var forceNewTabButtonHidden = false
  var initialLayoutComplete = false
  
  var availableResizeWidth: Float = 0
  // trackingArea
  weak var hoveredTab: TabView?
  var permanentSubviews = [NSView]()
  
  var mouseInside = false
  
  // hoverTabSelector
  
  init?(view: TabStripView, switchView: NSView,
       delegate: TabStripControllerDelegate)
  {
    self.tabStripView = view
    self.switchView = switchView
    // model
    // hoverTabSelector
    self.delegate = delegate
    // bridge
    // dragController
    // tabContentsArray
    // tabArray
    
    super.init(nibName: nil, bundle: nil)

    tabStripView.controller = self
  }
  
  required init?(coder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
}
