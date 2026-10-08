import SwiftUI

struct UploadView: View {
    @Environment(AppState.self) private var appState
    @State private var title = ""
    @State private var caption = ""
    @State private var selectedTags: Set<EditTag> = [.sync]
    @State private var durationSec = 20
    @State private var published = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Drop your cut")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(EVTheme.paper)

                    Text("MVP: Metadaten + Poster. Echter Video-Upload kommt mit Backend/Storage.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(EVTheme.mist)

                    EditPoster(
                        colors: [EVTheme.ink, EVTheme.acid, EVTheme.heat],
                        title: title.isEmpty ? "UNTITLED EDIT" : title,
                        beatDropAt: 0.55
                    )
                    .frame(height: 220)

                    field("Title", text: $title)
                    field("Caption", text: $caption, axis: .vertical)

                    VStack(alignment: .leading, spacing: 10) {
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
                                        .padding(.vertical, 10)
                                        .foregroundStyle(on ? EVTheme.ink : EVTheme.paper)
                                        .background(on ? EVTheme.acid : EVTheme.panel)
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .stroke(EVTheme.line, lineWidth: 1)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Duration: \(durationSec)s")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(EVTheme.mist)
                        Slider(value: Binding(
                            get: { Double(durationSec) },
                            set: { durationSec = Int($0) }
                        ), in: 3...90, step: 1)
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
                        Text("Publish · +80 XP")
                            .font(.system(size: 17, weight: .heavy))
                            .foregroundStyle(EVTheme.ink)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(EVTheme.acid)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
                .padding(16)
                .padding(.bottom, 28)
            }
            .background(EVTheme.ink.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .alert("Edit live", isPresented: $published) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Dein Edit ist im Feed — XP gutgeschrieben.")
            }
        }
    }

    private func field(_ label: String, text: Binding<String>, axis: Axis = .horizontal) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(EVTheme.mist)
            TextField(label, text: text, axis: axis)
                .lineLimit(axis == .vertical ? 3...6 : 1...1)
                .padding(14)
                .background(EVTheme.panel)
                .foregroundStyle(EVTheme.paper)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(EVTheme.line, lineWidth: 1)
                )
        }
    }
}
