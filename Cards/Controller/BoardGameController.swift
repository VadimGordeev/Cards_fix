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
    var cardsPairsCounts = 0
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
            print("Button was pressed")
        }), for: .touchUpInside)
        
        return button
        
    }

//    @objc func startGame(_ sender: UIButton) {
//        print("button was pressed")
//    }
}
