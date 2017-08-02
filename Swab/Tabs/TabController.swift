import Cocoa

protocol TabDraggingEventTarget
{
  func tabCanBeDragged(_ tab: TabController) -> Bool
  func maybeStartDrag(_ event: NSEvent, forTab tab: TabController)
}

class TabController
{
  var menu: NSMenu?
  var inRapidClosureMode = false
  
  func updateVisibility() {}
}

extension TabController: TabDraggingEventTarget
{
  func tabCanBeDragged(_ tab: TabController) -> Bool { return false }
  func maybeStartDrag(_ event: NSEvent, forTab tab: TabController) {}
}
