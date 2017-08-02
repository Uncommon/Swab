import Cocoa

class NewTabButton: NSButton
{
  
}

class TabStripView: NSView
{
  weak var controller: TabStripController?
  var lastMouseUp: TimeInterval = -1000
  // dropHandler
  let newTabButton: NewTabButton
  
  override init(frame frameRect: NSRect)
  {
    newTabButton = NewTabButton(frame: NSRect(x: 295, y: 0, width: 40, height: 27))
    newTabButton.toolTip = "New Tab"
    
    super.init(frame: frameRect)
    
    self.wantsLayer = true
  }
  
  required init?(coder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
}
