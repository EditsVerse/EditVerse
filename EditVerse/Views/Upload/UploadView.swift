import SwiftUI

struct UploadView: View {
    @Environment(AppState.self) private var appState
    @State private var title = ""
    @State private var caption = ""
    @State private var selectedTags: Set<EditTag> = [.sync]
    @State private var durationSec = 20
    @State private var published = false

    var body: some View {
        ZStack {
            EVTheme.void.ignoresSafeArea()
            LinearGradient(
                colors: [EVTheme.acid.opacity(0.16), .clear, EVTheme.heat.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("EDITVERSE")
                        .font(.system(size: 12, weight: .black))
                        .tracking(3)
                        .foregroundStyle(EVTheme.acid)
                    Text("DROP")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundStyle(EVTheme.paper)
                    Text("Composer for finished cuts. Video binary comes in Phase 1.")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(EVTheme.mist)

                    EditCanvas(
                        colors: [EVTheme.ink, EVTheme.acid, EVTheme.heat],
                        title: title.isEmpty ? "UNTITLED" : title,
                        beatDropAt: 0.55,
                        size: CGSize(width: 360, height: 220)
                    )
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .strokeBorder(.white.opacity(0.25), lineWidth: 1)
                    }

                    glassField("Title", text: $title)
                    glassField("Caption", text: $caption, axis: .vertical)

                    Text("Tags")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(EVTheme.mist)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 8)], spacing: 8) {
                        ForEach(EditTag.allCases) { tag in
                            let on = selectedTags.contains(tag)
                            Button {
                                if on { selectedTags.remove(tag) } else { selectedTags.insert(tag) }
                            } label: {
                                Text(tag.rawValue)
                                    .font(.system(size: 12, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .foregroundStyle(on ? EVTheme.ink : EVTheme.paper)
                                    .background {
                                        if on {
                                            RoundedRectangle(cornerRadius: 14, style: .continuous).fill(EVTheme.acid)
                                        } else {
                                            LiquidGlassBackground(cornerRadius: 14, intensity: 0.85)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Duration \(durationSec)s")
                            .font(EVTheme.hud)
                            .foregroundStyle(EVTheme.mist)
                        Slider(
                            value: Binding(
                                get: { Double(durationSec) },
                                set: { durationSec = Int($0) }
                            ),
                            in: 3...90,
                            step: 1
                        )
                        .tint(EVTheme.acid)
                    }

                    Button {
                        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                        appState.publishEdit(
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            caption: caption,
                            tags: Array(selectedTags),
                            durationSec: durationSec
                        )
                        published = true
                        title = ""
                        caption = ""
                        appState.selectedTab = .feed
                    } label: {
                        Text("PUBLISH · +80 XP")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                            .foregroundStyle(EVTheme.ink)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(EVTheme.acid)
                            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                            .shadow(color: EVTheme.acid.opacity(0.4), radius: 16, y: 6)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 18)
                .padding(.top, 64)
                .padding(.bottom, 120)
            }
        }
        .alert("Edit live", isPresented: $published) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Im Stage-Feed. XP gutgeschrieben.")
        }
    }

    private func glassField(_ label: String, text: Binding<String>, axis: Axis = .horizontal) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(EVTheme.mist)
            TextField(label, text: text, axis: axis)
                .lineLimit(axis == .vertical ? 3...6 : 1...1)
                .padding(16)
                .foregroundStyle(EVTheme.paper)
                .background { LiquidGlassBackground(cornerRadius: 18, intensity: 0.9) }
        }
    }
}
