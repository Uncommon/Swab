import Foundation

enum RestoreTabType
{
  case none, tab, window
}

protocol TabStripModelDelegate
{
  func addTab(at index: Int, foreground: Bool)
  
  var restoreTabType: RestoreTabType { get }
  func restoreTab()
}

class TabContents {}

class TabStripModelOrderController {}

class TabStripModel
{
  struct CloseType: OptionSet
  {
    let rawValue: Int
    
    static let none = CloseType(rawValue: 0)
    static let userGesture = CloseType(rawValue: 1 << 0)
    static let createHistoricalTab = CloseType(rawValue: 1 << 1)
  }
  
  struct AddTabType: OptionSet
  {
    let rawValue: Int
    
    static let none          = AddTabType(rawValue: 0)
    static let active        = AddTabType(rawValue: 1 << 0)
    static let pinned        = AddTabType(rawValue: 1 << 1)
    static let forceIndex    = AddTabType(rawValue: 1 << 2)
    static let inheritGroup  = AddTabType(rawValue: 1 << 3)
    static let inheritOpener = AddTabType(rawValue: 1 << 4)
  }
  
  enum NewTab
  {
    case button, command, contextMenu
  }
  
  private(set) var delegate: TabStripModelDelegate
  var tabsContents = [TabContents]()
  var count: Int { return tabsContents.count }
  var isEmpty: Bool { return tabsContents.isEmpty }
  var activeIndex: Int = 0
  private(set)var closingAll = false
  
  let orderConroller = TabStripModelOrderController()
  
  init(delegate: TabStripModelDelegate)
  {
    self.delegate = delegate
  }
  
  func contains(index: Int) -> Bool
  {
    return index >= 0 && index < count
  }
  
  private func constrainedInsertionIndex(_ index: Int) -> Int
  {
    return index
  }
  
  func insert(contents: TabContents, at index: Int, addTypes: AddTabType)
  {
    // delegate.willAdd(contents: contents)
    
    let index = constrainedInsertionIndex(index)
    
    closingAll = false
    
    tabsContents.insert(contents, at: index)
  }
  
  // replace contents
  // discard contents
  // detach contents
  // move contents
  
  func activateTab(at index: Int, userGesture: Bool)
  {
    
  }
  
  func activeContents() -> TabContents
  {
    return tabsContents[activeIndex]
  }
  
  func contents(at index: Int) -> TabContents?
  {
    return contains(index: index) ? tabsContents[index] : nil
  }
  
  func index(of contents: TabContents) -> Int?
  {
    return tabsContents.index(where: { $0 === contents })
  }
  
  func closeAllTabs()
  {
    closingAll = true
    //...
  }
}
