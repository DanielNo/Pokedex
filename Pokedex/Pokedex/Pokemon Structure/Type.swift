//
//  Type.swift
//  Pokedex
//
//  Created by Daniel No on 5/19/21.
//

import Foundation

public enum Type : Int{
    case normal = 0
    case fire = 1
    case water = 2
    case grass = 3
    case electric = 4
    case flying = 5
    case dragon = 6
    case bug = 7
    case ice = 8
    case ghost = 9
    case psychic = 10
    case fighting = 11
    case poison = 12
    case ground = 13
    case fairy = 14
    case rock = 15
//    case dark = 16
//    case steel = 17
}

extension Type{
    func superEffective()->[Type]{
        switch self {
        case .normal:
            return []
        case .fire:
            return [.ice,.grass,.bug]
        case .water:
            return [.fire,.ground,.rock]
        case .grass:
            return [.water,.ground,.rock]
        case .electric:
            return [.water,.flying]
        case .flying:
            return [.grass,.fighting,.bug]
        case .dragon:
            return [.dragon]
        case .bug:
            return [.grass,.psychic]
        case .ice:
            return [.grass,.ground,.rock,.dragon]
        case .ghost:
            return [.psychic,.ghost]
        case .psychic:
            return [.fighting,.poison]
        case .fighting:
            return [.normal]
        case .poison:
            return [.grass,.fairy]
        case .ground:
            return [.electric,.poison]
        case .fairy:
            return [.fighting]
        case .rock:
            return [.flying,.bug]
//        case .dark:
//            return [.ghost,.psychic]
//        case .steel:
//            return []
        }

    }
    
    func weakness()->[Type]{
        switch self {
        case .normal:
            return [.fighting]
        case .fire:
            return [.water]
        case .water:
            return [.electric]
        case .grass:
            return [.fire,.ice,.poison]
        case .electric:
            return [.ground]
        case .flying:
            return [.electric,.ice]
        case .dragon:
            return [.dragon]
        case .bug:
            return [.fire,.flying,.rock]
        case .ice:
            return [.fire]
        case .ghost:
            return [.ghost]
        case .psychic:
            return [.ghost,.bug]
        case .fighting:
            return [.flying,.psychic,.fairy]
        case .poison:
            return [.ground,.psychic]
        case .ground:
            return [.water,.grass,.ice]
        case .fairy:
            return [.poison]
        case .rock:
            return [.water,.grass,.ice]
//        case .dark:
//            return []
//        case .steel:
//            return []
        }
    }
    
    func resistance()->[Type]{
        switch self {
        case .normal:
            return []
        case .fire:
            return []
        case .water:
            return []
        case .grass:
            return []
        case .electric:
            return []
        case .flying:
            return [.normal]
        case .dragon:
            return []
        case .bug:
            return []
        case .ice:
            return []
        case .ghost:
            return []
        case .psychic:
            return []
        case .fighting:
            return []
        case .poison:
            return []
        case .ground:
            return []
        case .fairy:
            return []
        case .rock:
            return [.electric]
//        case .dark:
//            return []
//        case .steel:
//            return []
        }
    }

    
    
}

extension Type : CustomStringConvertible{
    public var description: String {
        switch self {
        case .normal:
            return "Normal"
        case .fire:
            return "Fire"
        case .water:
            return "Water"
        case .grass:
            return "Grass"
        case .flying:
            return "Flying"
        case .dragon:
            return "Dragon"
        case .bug:
            return "Bug"
        case .ice:
            return "Ice"
        case .ghost:
            return "Ghost"
        case .psychic:
            return "Psychic"
        case .fighting:
            return "Fighting"
        case .poison:
            return "Poison"
        case .ground:
            return "Ground"
        case .fairy:
            return "Fairy"
        case .rock:
            return "Rock"
        case .electric:
            return "Electric"
//        case .dark:
//            return "Dark"
//        case .steel:
//            return "Steel"
        }
    }
}

