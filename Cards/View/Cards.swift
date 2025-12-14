//
//  Cards.swift
//  Cards
//
//  Created by Vadim on 13/12/2025.
//

import UIKit

protocol FlippableView: UIView {
    var isFlipped: Bool { get set }
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
    var isInteractionLocked: Bool { get set }
    func flip(isHint: Bool)
}


class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    
    var isFlipped: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var isInteractionLocked = false
    var flipCompletionHandler: ((FlippableView) -> Void)?
    var isMatched = false
    
    func flip(isHint: Bool = false) {
        //        определяем, между какими представлениями осуществить переход
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        //        запуск анимированного перехода
        UIView
            .transition(
                from: fromView,
                to: toView,
                duration: 0.5,
                options: [.transitionFlipFromTop],
                completion: { _ in
                    if !isHint {
                        self.flipCompletionHandler?(self)
                    }
                }
            )
        //        isFlipped = !isFlipped
        isFlipped.toggle()
    }
    
    var color: UIColor!
    var cornerRadius = 20
    private var startTouchPoint: CGPoint!
    private var touchOffset = CGPoint.zero
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        
        setupBorders()
    }
    
    private func setupBorders() {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    override func draw(_ rect: CGRect) {
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isInteractionLocked { return }
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        // точка касания внутри карточки
        let locationInCard = touch.location(in: self)
        touchOffset = locationInCard
        // запоминаем стартовую позицию для flip
        startTouchPoint = frame.origin
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isInteractionLocked { return }
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first, let superview = superview else { return }
        
        // точка касания относительно доски
        let locationInSuperview = touch.location(in: superview)
        
        // вычисляем новые координаты с учётом смещения
        var newX = locationInSuperview.x - touchOffset.x
        var newY = locationInSuperview.y - touchOffset.y
        
        // ограничиваем по горизонтали
        newX = max(0, newX) // не меньше 0
        newX = min(superview.bounds.width - frame.width, newX)
        
        // ограничиваем по вертикали
        newY = max(0, newY)
        newY = min(superview.bounds.height - frame.height, newY)
        
        // применяем новые координаты
        frame.origin = CGPoint(x: newX, y: newY)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isInteractionLocked { return }
        super.touchesBegan(touches, with: event)
        
        if self.frame.origin == startTouchPoint {
            flip()
        }
    }

//    внутренний отступ представления
    private let margin: Int = 10
    
//    представление с лицевой стороной карты
    lazy var frontSideView: UIView = self.getFrontSideView()
//    представление с обратной стороной карты
    lazy var backSideView: UIView = self.getBackSideView()
    
    private func getFrontSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        
        let shapeView = UIView(
            frame: CGRect(
                x: margin,
                y: margin,
                width: Int(self.bounds.width)-margin*2,
                height: Int(self.bounds.height)-margin*2
            )
        )
        view.addSubview(shapeView)
        
//        cоздание слоя с фигурой
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        shapeView.layer.addSublayer(shapeLayer)
        
//        скругляем углы корневого слоя
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        return view
    }
    
    private func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        
        view.backgroundColor = .white
        
        switch["circle", "line"].randomElement()! {
        case "circle":
            let layer = BackSideCircle(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        case "line":
            let layer = BackSideLine(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        default:
            break
        }
        //        скругляем углы корневого слоя
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        return view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIResponder {
    func responderChain() -> String {
        guard let next = next else {
            return String (describing: Self.self)
        }
        return String(describing: Self.self) + " -> " + next.responderChain()
    }
}
