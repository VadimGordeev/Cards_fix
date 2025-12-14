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
    }
    
    //    изменение положения кнопки
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        startButtonView.center.x = view.center.x
        startButtonView.frame.origin.y = view.safeAreaInsets.top
        
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
//        1 Создание кнопки
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
//        2 Настройка внешнего вида кнопки
        button.setTitle("Start Game", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        
//        подключение обработчика нажатия на кнопку до iOS 14
//        button.addTarget(nil, action: #selector(startGame(_:)), for: .touchUpInside)
        button.addAction(UIAction(title: "Start Game", handler: { action in
            self.startGame()
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
                            (card as! FlippableView).flip()
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
}
