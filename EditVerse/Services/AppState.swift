import Foundation
import Observation
import SwiftUI

@Observable
final class AppState {
    var me: Creator
    var posts: [EditPost]
    var challenges: [Challenge]
    var achievements: [Achievement]
    var selectedTab: RootTab = .feed

    init() {
        me = MockData.me
        posts = MockData.posts
        challenges = MockData.challenges
        achievements = MockData.achievements
    }

    func creator(for id: String) -> Creator {
        if id == me.id { return me }
        return MockData.creator(for: id)
    }

    func toggleLike(_ post: EditPost) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        if posts[index].likedByMe {
            posts[index].likedByMe = false
            posts[index].likes = max(0, posts[index].likes - 1)
        } else {
            posts[index].likedByMe = true
            posts[index].likes += 1
            awardXP(8)
        }
    }

    func toggleSave(_ post: EditPost) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        if posts[index].savedByMe {
            posts[index].savedByMe = false
            posts[index].saves = max(0, posts[index].saves - 1)
        } else {
            posts[index].savedByMe = true
            posts[index].saves += 1
            awardXP(12)
        }
    }

    func publishEdit(title: String, caption: String, tags: [EditTag], durationSec: Int) {
        let post = EditPost(
            id: UUID().uuidString,
            creatorId: me.id,
            title: title,
            caption: caption,
            tags: tags,
            durationSec: durationSec,
            likes: 0,
            comments: 0,
            saves: 0,
            views: 0,
            xpAwarded: 80,
            createdAt: Date(),
            posterColors: [EVTheme.ink, EVTheme.acid, EVTheme.heat],
            beatDropAt: 0.55
        )
        posts.insert(post, at: 0)
        me.editsCount += 1
        me.streak += 1
        awardXP(80)
        unlock("a1")
        if me.streak >= 3 { unlock("a2") }
    }

    func awardXP(_ amount: Int) {
        me.xp += amount
    }

    private func unlock(_ id: String) {
        guard let index = achievements.firstIndex(where: { $0.id == id }) else { return }
        guard !achievements[index].unlocked else { return }
        achievements[index].unlocked = true
        awardXP(achievements[index].xp)
    }

    var leaderboard: [LeaderboardEntry] {
        var list = MockData.creators.filter { $0.id != me.id }
        list.append(me)
        return list
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

enum RootTab: Hashable {
    case feed, challenges, upload, ranks, profile
}
