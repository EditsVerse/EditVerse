import Foundation
import SwiftUI

enum MockData {
    static let me = Creator(
        id: "me",
        handle: "cutbyyou",
        displayName: "You",
        bio: "Cuts, drops, obsession.",
        xp: 1280,
        streak: 4,
        followers: 86,
        editsCount: 7,
        avatarHue: 0.22
    )

    static let creators: [Creator] = [
        me,
        Creator(id: "c1", handle: "nocturne", displayName: "Nocturne", bio: "Night sync only.", xp: 8420, streak: 19, followers: 12_400, editsCount: 118, avatarHue: 0.62),
        Creator(id: "c2", handle: "frameknife", displayName: "Frameknife", bio: "Hard cuts. Soft feelings.", xp: 3910, streak: 8, followers: 5_210, editsCount: 64, avatarHue: 0.08),
        Creator(id: "c3", handle: "beatmason", displayName: "Beatmason", bio: "Every hit lands.", xp: 15600, streak: 31, followers: 44_200, editsCount: 210, avatarHue: 0.41),
        Creator(id: "c4", handle: "vhsangel", displayName: "VHS Angel", bio: "Grain is a feature.", xp: 2200, streak: 2, followers: 1_880, editsCount: 29, avatarHue: 0.88),
    ]

    static var posts: [EditPost] = [
        EditPost(
            id: "p1",
            creatorId: "c3",
            title: "ONE DROP LEFT",
            caption: "Trailer energy, anime bones, zero mercy.",
            tags: [.trailer, .sync, .afterEffects],
            durationSec: 34,
            likes: 18_442,
            comments: 903,
            saves: 4_112,
            views: 402_110,
            xpAwarded: 240,
            createdAt: Date().addingTimeInterval(-3600 * 3),
            posterColors: [Color(hex: 0x1B2430), Color(hex: 0xFF6A3D), Color(hex: 0xC8F542)],
            beatDropAt: 0.62
        ),
        EditPost(
            id: "p2",
            creatorId: "c1",
            title: "rain / rewind",
            caption: "Aesthetic night drive. CapCut, but make it cinema.",
            tags: [.aesthetic, .capCut],
            durationSec: 22,
            likes: 9_201,
            comments: 411,
            saves: 2_008,
            views: 155_900,
            xpAwarded: 160,
            createdAt: Date().addingTimeInterval(-3600 * 8),
            posterColors: [Color(hex: 0x0E1A2B), Color(hex: 0x5CC8FF), Color(hex: 0x142033)],
            beatDropAt: 0.48
        ),
        EditPost(
            id: "p3",
            creatorId: "c2",
            title: "BLADE TRANSITION PACK",
            caption: "12 whip cuts. Steal the timing, not the clips.",
            tags: [.transition, .premiere],
            durationSec: 18,
            likes: 6_774,
            comments: 288,
            saves: 3_540,
            views: 98_220,
            xpAwarded: 190,
            createdAt: Date().addingTimeInterval(-3600 * 14),
            posterColors: [Color(hex: 0x201016), Color(hex: 0xFF3D6E), Color(hex: 0xF0FF66)],
            beatDropAt: 0.33
        ),
        EditPost(
            id: "p4",
            creatorId: "c4",
            title: "soft amv / hard heart",
            caption: "VHS bloom + piano hit. Comments closed for feelings.",
            tags: [.amv, .aesthetic],
            durationSec: 41,
            likes: 4_105,
            comments: 176,
            saves: 990,
            views: 61_040,
            xpAwarded: 140,
            createdAt: Date().addingTimeInterval(-3600 * 26),
            posterColors: [Color(hex: 0x24182A), Color(hex: 0xE8A0FF), Color(hex: 0xC8F542)],
            beatDropAt: 0.71
        ),
        EditPost(
            id: "p5",
            creatorId: "me",
            title: "first real sync",
            caption: "Still learning. Drop hits at 0:09.",
            tags: [.sync, .capCut],
            durationSec: 16,
            likes: 128,
            comments: 14,
            saves: 22,
            views: 940,
            xpAwarded: 80,
            createdAt: Date().addingTimeInterval(-3600 * 40),
            posterColors: [Color(hex: 0x121418), Color(hex: 0xC8F542), Color(hex: 0x2A3140)],
            beatDropAt: 0.56
        ),
    ]

    static let challenges: [Challenge] = [
        Challenge(id: "ch1", title: "Silent Drop", brief: "No lyrics. One beat drop. Make the cut scream.", tag: .sync, endsInHours: 38, prizeXP: 1200, entrants: 842, difficulty: .hard),
        Challenge(id: "ch2", title: "3-Second Whip", brief: "Whole edit under 3 seconds. Pure transition flex.", tag: .transition, endsInHours: 12, prizeXP: 600, entrants: 1_904, difficulty: .easy),
        Challenge(id: "ch3", title: "Legend Trailer", brief: "Movie trailer energy for a story that doesn’t exist.", tag: .trailer, endsInHours: 72, prizeXP: 3000, entrants: 221, difficulty: .legend),
    ]

    static let achievements: [Achievement] = [
        Achievement(id: "a1", title: "First Cut", detail: "Upload your first edit", xp: 50, unlocked: true),
        Achievement(id: "a2", title: "Streak Starter", detail: "Post 3 days in a row", xp: 120, unlocked: true),
        Achievement(id: "a3", title: "Drop Sniper", detail: "Hit a challenge top 10", xp: 400, unlocked: false),
        Achievement(id: "a4", title: "Saved 100x", detail: "Get 100 saves on one edit", xp: 300, unlocked: false),
        Achievement(id: "a5", title: "Timeline God Path", detail: "Reach 10,000 XP", xp: 0, unlocked: false),
    ]

    static func creator(for id: String) -> Creator {
        creators.first(where: { $0.id == id }) ?? me
    }

    static func leaderboard() -> [LeaderboardEntry] {
        creators
            .sorted { $0.xp > $1.xp }
            .enumerated()
            .map { index, creator in
                LeaderboardEntry(
                    id: creator.id,
                    creator: creator,
                    weeklyXP: max(120, creator.xp / 7),
                    place: index + 1
                )
            }
    }
}
