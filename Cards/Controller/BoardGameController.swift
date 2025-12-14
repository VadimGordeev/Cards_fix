//
//  BoardGameController.swift
//  Cards
//
//  Created by Vadim on 13/12/2025.
//

import UIKit

class BoardGameController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(startButtonView)
        view.addSubview(boardGameView)
        view.addSubview(hintButtonView)
    }
    
    //    изменение положения кнопки
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        startButtonView.frame.origin.x = 20
        startButtonView.frame.origin.y = view.safeAreaInsets.top
            
        hintButtonView.frame.origin.x = view.bounds.width - hintButtonView.frame.width - 20
        hintButtonView.frame.origin.y = view.safeAreaInsets.top
        
        let margin: CGFloat = 10
        boardGameView.frame = CGRect(
            x: margin,
            y: startButtonView.frame.maxY + margin,
            width: view.bounds.width - margin * 2,
            height: view.bounds.height
            - (startButtonView.frame.maxY + margin)
            - view.safeAreaInsets.bottom
            - margin
        )
        startGame()
    }
    
//    количество пар уникальных карточек
    var cardsPairsCounts = 5
//    сущность "Игра"
    lazy var game: Game = getNewGame()
    
    private func getNewGame() -> Game {
        let game = Game()
        game.cardsCount = self.cardsPairsCounts
        game.generateCards()
        return game
    }

//    кнопка для запуска/перезапуска игры
    lazy var startButtonView = getStartButtonView()
//    кнопка подсказки
    lazy var hintButtonView = getHintButtonView()
//    игровое поле
    lazy var boardGameView = getBoardGameView()
    
//    размеры карточек
    private var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
    
//    предельные координаты размещения карточки
    private var cardMaxXCoordinate: Int {
        Int(boardGameView.frame.width - cardSize.width)
    }
    private var cardMaxYCoordinate: Int {
        Int(boardGameView.frame.height - cardSize.height)
    }
    
    private var flippedCards = [UIView]()
    
//    игральные карточки
    var cardViews = [UIView]()
    
    private func getBoardGameView() -> UIView {
//        отступ игрового поля от ближайших элементов
        let boardView = UIView()
        
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
        
        return boardView
    }
    
    private func getStartButtonView() -> UIButton {
//    // 1 создание кнопки
        let button = UIButton(type: .system)

        // 2 настройка внешнего вида через конфигурацию
        var config = UIButton.Configuration.filled()
        config.title = "Restart Game"
        config.baseBackgroundColor = .systemGray4
        config.baseForegroundColor = .black

        // внутренние отступы
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)

        // присваиваем конфигурацию кнопке
        button.configuration = config

        // скругление углов (через layer)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true

        // подгонка размера под текст + отступы
        button.sizeToFit()
        
//        подключение обработчика нажатия на кнопку до iOS 14
//        button.addTarget(nil, action: #selector(startGame(_:)), for: .touchUpInside)
        button.addAction(UIAction(title: "Restart Game", handler: { action in
            self.startGame()
        }), for: .touchUpInside)
        
        return button
    }
    
    private func getHintButtonView() -> UIButton {
        let button = UIButton(type: .system)

        // создаем конфигурацию
        var config = UIButton.Configuration.filled()
        config.title = "Show Hint"
        config.baseBackgroundColor = .systemGray4
        config.baseForegroundColor = .black

        // внутренние отступы
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)

        // присваиваем конфигурацию кнопке
        button.configuration = config

        // скругление углов
        button.layer.cornerRadius = 10
        button.clipsToBounds = true

        // размер под текст + отступы
        button.sizeToFit()
        
        button.addAction(UIAction(title: "Show hint", handler: { action in
            self.showHint()
        }), for: .touchUpInside)
        
        return button
    }
    
//    генерация массива карточек на основе данных модели
    private func getCardsBy(modelData: [Card]) -> [UIView] {
//        хранилище для представлений карточек
        var cardViews = [UIView]()
//        фабрика карточек
        let cardViewFactory = CardViewFactory()
//        перебор массива карточек в модели
        for (index, modelCard) in modelData.enumerated() {
//            добавляем первый экземпляр карты
            let cardOne = cardViewFactory.get(
                modelCard.type,
                withSize: cardSize,
                andColor: modelCard.color
            )
            cardOne.tag = index
            cardViews.append(cardOne)
            
//            добавляем второй экземпляр карты
            let cardTwo = cardViewFactory.get(
                modelCard.type,
                withSize: cardSize,
                andColor: modelCard.color
            )
            cardTwo.tag = index
            cardViews.append(cardTwo)
        }
//        добавляем всем картам обработчик переворота
        for card in cardViews {
            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
//            перенос карты вверх иерархии
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                
//                добавляем или удаляем карточку
                if flippedCard.isFlipped {
                    self.flippedCards.append(flippedCard)
                } else {
                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                        self.flippedCards.remove(at: cardIndex)
                    }
                }
                
//                если перевернуто 2 карточки
                if self.flippedCards.count == 2 {
//                    получаем карточки из данных модели
                    let firstCard = game.cards[self.flippedCards.first!.tag]
                    let secondCard = game.cards[self.flippedCards.last!.tag]
                    
//                    если карточки одинаковые
                    if game.checkCards(firstCard, secondCard) {
//                        анимированно скрываем их
                        UIView.animate(withDuration: 0.3, animations: {
                            self.flippedCards.first!.layer.opacity = 0
                            self.flippedCards.last!.layer.opacity = 0
//                            после чего удаляем из иерархии
                        }, completion: { _ in
                            self.flippedCards.first!.removeFromSuperview()
                            self.flippedCards.last!.removeFromSuperview()
                            self.flippedCards = []
                        })
//                        в ином случае
                    } else {
//                        переворачиваем карточки рубашкой вверх
                        for card in self.flippedCards {
                            (card as! FlippableView).flip(isHint: false)
                        }
                    }
                }
            }
        }
        return cardViews
    }
    
    private func placeCardsOnBoard(_ cards: [UIView]) {
//        удаляем все имеющиеся на игровом поле карточки
        for card in cardViews {
            card.removeFromSuperview()
        }
        cardViews = cards
//        перебор карточек
        for card in cardViews {
//            для каждой карточки генерируем случайные координаты
            let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
            let randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
            card.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
//            размещение карточки на игровом поле
            boardGameView.addSubview(card)
        }
    }

    func startGame() {
        game = getNewGame()
        let cards = getCardsBy(modelData: game.cards)
        placeCardsOnBoard(cards)
    }
    
    func showHint() {
        var hintCards = [FlippableView]()

        // переворачиваем все карты рубашкой вниз, которые еще не перевернуты
        for card in cardViews {
            let flippable = card as! FlippableView
            if !flippable.isFlipped {
                flippable.isInteractionLocked = true
                flippable.flip(isHint: true)   // только переворот, не трогаем flippedCards
                hintCards.append(flippable)
            }
        }

        // через 1 секунду переворачиваем обратно
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for card in hintCards {
                card.flip(isHint: true)
                card.isInteractionLocked = false
            }
        }
    }
}
