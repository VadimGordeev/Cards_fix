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
        print("BoardGameController loaded")
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(startButtonView)
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
    
    private func getStartButtonView() -> UIButton {
//        1 Создание кнопки
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
//        2 Изменение положения
        button.center.x = view.center.x
//        3 Настройка внешнего вида кнопки
        button.setTitle("Start Game", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        
        return button
        
    }

}
