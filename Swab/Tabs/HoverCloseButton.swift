import Cocoa

class HoverButton: NSButton
{
  enum HoverState
  {
    case none, mouseOver, mouseDown
  }
  
  var hoverState = HoverState.none
  {
    didSet
    {
      needsDisplay = hoverState != oldValue
    }
  }
  
  var trackingArea: NSTrackingArea?
  
  override init(frame frameRect: NSRect)
  {
    super.init(frame: frameRect)
    setUpTracking()
  }
  
  required init?(coder: NSCoder)
  {
    fatalError("Not implemented")
  }
  
  deinit
  {
    setTrackingEnabled(false)
  }
  
  override func awakeFromNib()
  {
    setUpTracking()
  }
  
  override func mouseEntered(with event: NSEvent)
  {
    if trackingArea != nil {
      hoverState = .mouseOver
    }
  }
  
  override func mouseExited(with event: NSEvent)
  {
    if trackingArea != nil {
      hoverState = .none
    }
  }
  
  override func mouseMoved(with event: NSEvent)
  {
    checkImageState()
  }
  
  override func mouseDown(with event: NSEvent)
  {
    hoverState = .mouseDown
    super.mouseDown(with: event)
    checkImageState()
  }
  
  override func updateTrackingAreas()
  {
    super.updateTrackingAreas()
    checkImageState()
  }
  
  private func setUpTracking()
  {
    setTrackingEnabled(true)
    hoverState = .none
    updateTrackingAreas()
  }
  
  private func checkImageState()
  {
    guard trackingArea != nil,
      let window = self.window
      else { return }
    
    let mouse = window.mouseLocationOutsideOfEventStream
    let windowMouse = convert(mouse, from: nil)
    
    hoverState = NSPointInRect(windowMouse, bounds) ? .mouseOver : .none
  }
  
  func setTrackingEnabled(_ enabled: Bool)
  {
    if enabled {
      let trackingArea = NSTrackingArea(
        rect: NSZeroRect,
        options: [.mouseEnteredAndExited, .mouseMoved,
                  .activeAlways, .inVisibleRect],
        owner: self, userInfo: nil)
      
      self.trackingArea = trackingArea
      addTrackingArea(trackingArea)
      
      DispatchQueue.main.async {
        [weak self] in self?.checkImageState()
      }
    }
    else {
      if let trackingArea = self.trackingArea {
        hoverState = .none
        removeTrackingArea(trackingArea)
        self.trackingArea = nil
      }
    }
  }
}

class HoverCloseButton: HoverButton
{
}
