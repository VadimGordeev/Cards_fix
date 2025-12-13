//
//  Game.swift
//  Cards
//
//  Created by Vadim on 13/12/2025.
//

class Game {
//    количество пар уникальных карточек
    var cardsCount = 0
//    массив сгенерированных карточек
    var cards = [Card]()
    
//    генерация массива случайных карт
    func generateCards() {
        var cards = [Card]()
        for _ in 0...cardsCount {
            let randomElement = (
                type: CardType.allCases.randomElement()!,
                color: CardColor.allCases
                    .randomElement()!)
            cards.append(randomElement)
        }
        self.cards = cards
    }
    
//    проверка эквивалентности карточек
    func checkCards(_ card1: Card, _ card2: Card) -> Bool {
        if card1 == card2 {
            return true
        }
        return false
    }
}
