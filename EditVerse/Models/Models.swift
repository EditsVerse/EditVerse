import Foundation
import SwiftUI

enum EditTag: String, CaseIterable, Identifiable, Hashable {
    case amv = "AMV"
    case aesthetic = "Aesthetic"
    case transition = "Transition"
    case sync = "Sync"
    case trailer = "Trailer"
    case capCut = "CapCut"
    case afterEffects = "After Effects"
    case premiere = "Premiere"

    var id: String { rawValue }
}

enum Rank: String, CaseIterable, Identifiable {
    case cutter = "Cutter"
    case framer = "Framer"
    case syncer = "Syncer"
    case dropLord = "Drop Lord"
    case timelineGod = "Timeline God"
    case editverse = "EditVerse"

    var id: String { rawValue }

    var minXP: Int {
        switch self {
        case .cutter: 0
        case .framer: 500
        case .syncer: 1_500
        case .dropLord: 4_000
        case .timelineGod: 10_000
        case .editverse: 25_000
        }
    }

    var accent: Color {
        switch self {
        case .cutter: Color(hex: 0x8A93A3)
        case .framer: Color(hex: 0x5CC8FF)
        case .syncer: Color(hex: 0xC8F542)
        case .dropLord: Color(hex: 0xFF6A3D)
        case .timelineGod: Color(hex: 0xFFD166)
        case .editverse: Color(hex: 0xF0FF66)
        }
    }

    static func from(xp: Int) -> Rank {
        Rank.allCases.last(where: { xp >= $0.minXP }) ?? .cutter
    }

    var next: Rank? {
        guard let index = Rank.allCases.firstIndex(of: self),
              index + 1 < Rank.allCases.count else { return nil }
        return Rank.allCases[index + 1]
    }
}

struct Creator: Identifiable, Hashable {
    let id: String
    var handle: String
    var displayName: String
    var bio: String
    var xp: Int
    var streak: Int
    var followers: Int
    var editsCount: Int
    var avatarHue: Double

    var rank: Rank { Rank.from(xp: xp) }
}

struct EditPost: Identifiable, Hashable {
    let id: String
    let creatorId: String
    var title: String
    var caption: String
    var tags: [EditTag]
    var durationSec: Int
    var likes: Int
    var comments: Int
    var saves: Int
    var views: Int
    var xpAwarded: Int
    var createdAt: Date
    var posterColors: [Color]
    var beatDropAt: Double
    var likedByMe: Bool = false
    var savedByMe: Bool = false
}

struct Challenge: Identifiable, Hashable {
    let id: String
    var title: String
    var brief: String
    var tag: EditTag
    var endsInHours: Int
    var prizeXP: Int
    var entrants: Int
    var difficulty: Difficulty

    enum Difficulty: String, Hashable {
        case easy = "Easy"
        case hard = "Hard"
        case legend = "Legend"
    }
}

struct Achievement: Identifiable, Hashable {
    let id: String
    var title: String
    var detail: String
    var xp: Int
    var unlocked: Bool
}

struct LeaderboardEntry: Identifiable, Hashable {
    let id: String
    var creator: Creator
    var weeklyXP: Int
    var place: Int
}
