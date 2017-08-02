import Cocoa

class TabView: NSView
{
  struct Durations
  {
    static let hoverShow: TimeInterval = 0.2
    static let hoverHold: TimeInterval = 0.02
    static let hoverHide: TimeInterval = 0.4
    static let alertShow: TimeInterval = 0.4
    static let alertHold: TimeInterval = 0.4
    static let alertHide: TimeInterval = 0.4
  }
  
  var controller: TabController
  var titleView: NSTextField
  // titleViewCell
  var closeButton: HoverCloseButton
  
  var isClosing = false
  {
    didSet
    {
      if isClosing {
        closeButton.target = nil
        closeButton.action = nil
      }
    }
  }
  var isMouseInside = false
  var hoverAlpha: Float = 0
  var hoverHoldEndTime: TimeInterval = 0
  var lastGlowUpdate = NSDate.timeIntervalSinceReferenceDate
  var hoverPoint: NSPoint = NSZeroPoint
  
  var mouseDownPoint: NSPoint?
  var state: NSCellStateValue = NSOnState
  
  var toolTipText: String?
  
  var maskCache: CGImage?
  var maskCacheWidth: CGFloat = 0
  var maskCacheHeight: CGFloat = 0
  
  init(frame: NSRect, controller: TabController, closeButton: HoverCloseButton)
  {
    self.controller = controller
    self.closeButton = closeButton
    self.titleView = NSTextField()
    
    super.init(frame: frame)
    
    titleView.autoresizingMask = .viewWidthSizable
    
    // title view cell
  }
  
  required init?(coder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var menu: NSMenu?
    {
    get
    {
      return controller.menu
    }
    set {}
  }
  
  override func resizeSubviews(withOldSize oldSize: NSSize)
  {
    super.resizeSubviews(withOldSize: oldSize)
    controller.updateVisibility()
  }
  
  override func acceptsFirstMouse(for event: NSEvent?) -> Bool
  {
    return true
  }
  
  override func mouseEntered(with event: NSEvent)
  {
    isMouseInside = true
    resetLastGlowUpdateTime()
    adjustGlowValue()
  }
  
  override func mouseMoved(with event: NSEvent)
  {
    hoverPoint = convert(event.locationInWindow, from: nil)
    needsDisplay = true
  }
  
  override func mouseExited(with event: NSEvent)
  {
    isMouseInside = false
    hoverHoldEndTime = Date.timeIntervalSinceReferenceDate + Durations.hoverHold
    resetLastGlowUpdateTime()
    adjustGlowValue()
  }
  
  // Is this supposed to be an override?
  func setTrackingEnabled(_ enabled: Bool)
  {
    if !closeButton.isHidden {
      closeButton.setTrackingEnabled(enabled)
    }
  }
  
  override func hitTest(_ point: NSPoint) -> NSView?
  {
    let viewPoint = convert(point, from: superview)
    
    if !closeButton.isHidden &&
      NSPointInRect(viewPoint, closeButton.frame) {
      return closeButton
    }
    
    let pointRect = NSRect(x: viewPoint.x, y: viewPoint.y,
                           width: 1, height: 1)
    
    // hit testing using the image
    
    return nil
  }
  
  // canBeDragged - not used?
  
  override func mouseDown(with event: NSEvent)
  {
    guard !isClosing
      else { return }
    
    mouseDownPoint = event.locationInWindow
    
    if !closeButton.isHidden && self.controller.inRapidClosureMode,
      let hitLocation = superview?.convert(event.locationInWindow,
                                           from: nil) {
      if hitTest(hitLocation) == closeButton {
        closeButton.mouseDown(with: event)
        return
      }
    }
    
    // May be needed to retain things during the drag
    let controller = self.controller
    
    controller.maybeStartDrag(event, forTab: controller)
    mouseDownPoint = nil
  }
  
  private func resetLastGlowUpdateTime()
  {
    lastGlowUpdate = Date.timeIntervalSinceReferenceDate
  }
  
  private func timeIntervalSinceLastGlowUpdate() -> TimeInterval
  {
    return Date.timeIntervalSinceReferenceDate - lastGlowUpdate
  }
  
  private func adjustGlowValue() {}
}
