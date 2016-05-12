// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import UIKit

extension UIColor {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}

extension UIColor {
  enum Name {
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f2f2f3"></span>
    /// Alpha: 100% <br/> (0xf2f2f3ff)
    case Background
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#2e3134"></span>
    /// Alpha: 100% <br/> (0x2e3134ff)
    case Bar
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#257f17"></span>
    /// Alpha: 100% <br/> (0x257f17ff)
    case ButtonTint
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#282828"></span>
    /// Alpha: 100% <br/> (0x282828ff)
    case DarkText
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ecedee"></span>
    /// Alpha: 100% <br/> (0xecedeeff)
    case DetailBackground
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#696e72"></span>
    /// Alpha: 100% <br/> (0x696e72ff)
    case LightText

    var rgbaValue: UInt32! {
      switch self {
      case .Background: return 0xf2f2f3ff
      case .Bar: return 0x2e3134ff
      case .ButtonTint: return 0x257f17ff
      case .DarkText: return 0x282828ff
      case .DetailBackground: return 0xecedeeff
      case .LightText: return 0x696e72ff
      }
    }
  }

  convenience init(named name: Name) {
    self.init(rgbaValue: name.rgbaValue)
  }
}
