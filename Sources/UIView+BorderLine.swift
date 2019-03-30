//
//  UIView+BorderLine.swift
//  QAHelp
//
//  Created by Deng Jinlong on 2018/7/9.
//  Copyright © 2018 TVGuo. All rights reserved.
//

import UIKit

private struct BorderLineConst {
    static var topKey: NSObject = NSObject()
    static var bottomKey: NSObject = NSObject()
    static var leftKey: NSObject = NSObject()
    static var rightKey: NSObject = NSObject()
    static let lineColor: UIColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1) //0xeeeeee
}

private final class BorderLine: UIView {}

extension UIView {

    private func setLine(_ line: UIView?, for position: UIRectEdge) {
        switch position {
        case UIRectEdge.top:
            objc_setAssociatedObject(self, &BorderLineConst.topKey, line, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        case UIRectEdge.left:
            objc_setAssociatedObject(self, &BorderLineConst.leftKey, line, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        case UIRectEdge.bottom:
            objc_setAssociatedObject(self, &BorderLineConst.bottomKey, line, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        case UIRectEdge.right:
            objc_setAssociatedObject(self, &BorderLineConst.rightKey, line, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        default:
            objc_setAssociatedObject(self, &BorderLineConst.topKey, line, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    private func getLine(position: UIRectEdge) -> UIView? {
        switch position {
        case UIRectEdge.top:
            return objc_getAssociatedObject(self, &BorderLineConst.topKey) as? UIView
        case UIRectEdge.left:
            return objc_getAssociatedObject(self, &BorderLineConst.leftKey) as? UIView
        case UIRectEdge.bottom:
            return objc_getAssociatedObject(self, &BorderLineConst.bottomKey) as? UIView
        case UIRectEdge.right:
            return objc_getAssociatedObject(self, &BorderLineConst.rightKey) as? UIView
        default:
            return objc_getAssociatedObject(self, &BorderLineConst.topKey) as? UIView
        }
    }
    /**
     *  用autolayout在view上添加一个像素的线，
     *  重复添加无效，先删除再加加新线
     *  NOTE: 如果label text 重新绘制会盖住线条，发现无法添加线条时，使用container
     *
     *  @param lineWidth 线粗细，默认1px
     *  @param edge 代表上下左右位置
     *  @param insets 代表偏移
     */
    @objc
    public func addLine(_ position: UIRectEdge, insets: UIEdgeInsets = .zero, color: UIColor? = nil, lineWidth: CGFloat = UIView.onePixel) {
        if getLine(position: position) != nil {
            return // 这个位置的线条存在，直接返回
        }
        let line = BorderLine()
        line.backgroundColor = color ?? BorderLineConst.lineColor
        line.translatesAutoresizingMaskIntoConstraints = false
        #if YOGA
        line.yoga.isIncludedInLayout = false
        #endif
        self.addSubview(line)

        let dict = ["line": line]

        var constraints: [NSLayoutConstraint] = []

        if position == .top {
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(\(lineWidth))]", options: [], metrics: nil, views: dict)
            )
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(insets.left)-[line]-\(insets.right)-|", options: [], metrics: nil, views: dict)
            )
        } else if position == .bottom {
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "V:[line(\(lineWidth))]|", options: [], metrics: nil, views: dict)
            )
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(insets.left)-[line]-\(insets.right)-|", options: [], metrics: nil, views: dict)
            )
        } else if position == .left {
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(insets.top)-[line]-\(insets.bottom)-|", options: [], metrics: nil, views: dict)
            )
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "H:|[line(\(lineWidth))]", options: [], metrics: nil, views: dict)
            )
        } else if position == .right {
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(insets.top)-[line]-\(insets.bottom)-|", options: [], metrics: nil, views: dict)
            )
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "H:[line(\(lineWidth))]|", options: [], metrics: nil, views: dict)
            )
        }

        addConstraints(constraints)
        setLine(line, for: position)
    }
    @objc
    public func removeLine(_ position: UIRectEdge) {
        if let line = getLine(position: position) {
            line.removeFromSuperview()
            setLine(nil, for: position)
        }
    }

}

extension Array where Element: UIView {
    public func addGroupedCellLines(insets: UIEdgeInsets = .zero, color: UIColor? = nil, lineWidth: CGFloat = UIView.onePixel) {
        for (index, view) in enumerated() {
            if index == 0 { continue }
            view.addLine(.top, insets: insets, color: color, lineWidth: lineWidth)
        }
    }
}

extension Array where Element: TableViewCellViewModel {
    public func addGroupedCellLines(insets: UIEdgeInsets = .zero, color: UIColor? = nil) {
        for (index, model) in enumerated() {
            if index == 0 { continue }
            model.showTopLine = true
            model.lineIndent = insets
            if let color = color {
                model.lineColor = color
            }
        }
    }
}

extension UIView {
    public static let onePixel: CGFloat = 1.0/UIScreen.main.scale
    @objc public var onePixel: CGFloat {
        return UIView.onePixel
    }
}
