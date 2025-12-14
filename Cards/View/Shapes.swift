//
//  Shapes.swift
//  Cards
//
//  Created by Vadim on 13/12/2025.
//

import UIKit

protocol ShapeLayerProtocol: CAShapeLayer {
    init(size: CGSize, fillColor: CGColor)
}

extension ShapeLayerProtocol {
    init() {
        fatalError("init() has not been implemented")
    }
}

class BackSideCircle: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let path = UIBezierPath()
        
        for _ in 1...15 {
//            координаты центра очередного круга
            let randomX = Int.random(in: 0...Int(size.width))
            let randomY = Int.random(in: 0...Int(size.height))
            let center = CGPoint(x: randomX, y: randomY)
//            смещаем указатель к центру круга
            path.move(to: center)
//            определяем случайный радиус
            let radius = Int.random(in: 5...15)
//            рисуем круг
            path
                .addArc(
                    withCenter: center,
                    radius: CGFloat(radius),
                    startAngle: 0,
                    endAngle: .pi*2,
                    clockwise: true
                )
        }
        
        self.path = path.cgPath
        self.fillColor = fillColor
        self.strokeColor = fillColor
        self.lineWidth = 1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BackSideLine: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let path = UIBezierPath()
        
        for _ in 1...15 {
            //            координаты начала очередной линии
            let randomXStart = Int.random(in: 0...Int(size.width))
            let randomYStart = Int.random(in: 0...Int(size.height))
            //            координаты конца очередной линии
            let randomXEnd = Int.random(in: 0...Int(size.width))
            let randomYEnd = Int.random(in: 0...Int(size.height))
            //            смещаем указатель к началу линии
            path.move(to: CGPoint(x: randomXStart, y: randomYStart))
            //            рисуем линию
            path.addLine(to: CGPoint(x: randomXEnd, y: randomYEnd))
        }
        
        self.path = path.cgPath
        self.strokeColor = fillColor
        self.lineWidth = 3
        self.lineCap = .round
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FillShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.path = path.cgPath
        self.fillColor = fillColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CrossShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.move(to: CGPoint(x: size.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: size.height))
        self.path = path.cgPath
        self.strokeColor = fillColor
        self.lineWidth = 5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CircleShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
//        рассчитываем данные для круга, радиус равен половине меньшей из сторон
        let radius = ([size.width, size.height].min() ?? 0) / 2
//        центр круга равен центрам каждой из сторон
        let centerX = size.width / 2
        let centerY = size.height / 2
        
//        рисуем круг
        let path = UIBezierPath(
            arcCenter: CGPoint(x: centerX, y: centerY),
            radius: radius,
            startAngle: 0,
            endAngle: .pi*2,
            clockwise: true
        )
        path.close()
//        инициализируем созданный путь
        self.path = path.cgPath
        self.fillColor = fillColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UnfillCircleShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
//        рассчитываем данные для круга, радиус равен половине меньшей из сторон
        let radius = ([size.width, size.height].min() ?? 0) / 2
//        центр круга равен центрам каждой из сторон
        let centerX = size.width / 2
        let centerY = size.height / 2
        
//        рисуем круг
        let path = UIBezierPath(
            arcCenter: CGPoint(x: centerX, y: centerY),
            radius: radius,
            startAngle: 0,
            endAngle: .pi*2,
            clockwise: true
        )
        path.close()
//        инициализируем созданный путь
        self.path = path.cgPath
        self.strokeColor = fillColor
        self.lineWidth = 5
        self.fillColor = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SquareShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
//        сторона равна меньшей из сторон
        let edgeSize = ([size.width, size.height].min() ?? 0)
//        рисуем квадрат
        let rect = CGRect(x: 0, y: 0, width: edgeSize, height: edgeSize)
        let path = UIBezierPath(rect: rect)
        path.close()
        self.path = path.cgPath
        self.fillColor = fillColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
