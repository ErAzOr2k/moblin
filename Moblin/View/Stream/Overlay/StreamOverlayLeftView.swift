import SwiftUI
import WebKit

struct LeftOverlayView: View {
    @EnvironmentObject var model: Model

    var database: Database {
        model.settings.database
    }

    func viewersText() -> String {
        if !model.isViewersConfigured() {
            return String(localized: "Not configured")
        } else if model.isTwitchPubSubConnected() {
            return model.numberOfViewers
        } else {
            return ""
        }
    }

    func viewersColor() -> Color {
        if model.stream.twitchChannelId == "" {
            return .white
        } else if model.isTwitchPubSubConnected() {
            return .white
        } else {
            return .red
        }
    }

    func messageText() -> String {
        if !model.isChatConfigured() {
            return String(localized: "Not configured")
        } else if model.isChatConnected() {
            return String(
                format: String(localized: "%@ (%@ total)"),
                model.chatPostsRate,
                countFormatter.format(model.chatPostsTotal)
            )
        } else {
            return ""
        }
    }

    func messageColor() -> Color {
        if !model.isChatConfigured() {
            return .white
        } else if model.isChatConnected() && model.hasChatEmotes() {
            return .white
        } else {
            return .red
        }
    }

    func obsStatusText() -> String {
        if !model.isObsRemoteControlConfigured() {
            return String(localized: "Not configured")
        } else if model.isObsConnected() {
            if model.obsStreaming && model.obsRecording {
                return "\(model.obsCurrentScene) (Streaming, Recording)"
            } else if model.obsStreaming {
                return "\(model.obsCurrentScene) (Streaming)"
            } else if model.obsRecording {
                return "\(model.obsCurrentScene) (Recording)"
            } else {
                return model.obsCurrentScene
            }
        } else {
            return model.obsConnectionErrorMessage()
        }
    }

    func obsStatusColor() -> Color {
        if !model.isObsRemoteControlConfigured() {
            return .white
        } else if model.isObsConnected() {
            return .white
        } else {
            return .red
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            if model.isShowingStatusStream() {
                StreamOverlayIconAndTextView(
                    icon: "dot.radiowaves.left.and.right",
                    text: model.statusStreamText()
                )
            }
            if database.show.cameras! {
                StreamOverlayIconAndTextView(
                    icon: "camera",
                    text: model.getCameraPosition(scene: model.findEnabledScene(id: model.selectedSceneId))
                )
            }
            if database.show.microphone {
                StreamOverlayIconAndTextView(
                    icon: "music.mic",
                    text: model.mic.name
                )
            }
            if database.show.zoom && model.hasZoom {
                StreamOverlayIconAndTextView(
                    icon: "magnifyingglass",
                    text: String(format: "%.1f", model.zoomX)
                )
            }
            if model.database.show.obsStatus! && model.isObsRemoteControlConfigured() {
                StreamOverlayIconAndTextView(
                    icon: "xserve",
                    text: obsStatusText(),
                    color: obsStatusColor()
                )
            }
            if model.database.show.chat && model.isChatConfigured() {
                StreamOverlayIconAndTextView(
                    icon: "message",
                    text: messageText(),
                    color: messageColor()
                )
            }
            if database.show.viewers && model.isViewersConfigured() {
                StreamOverlayIconAndTextView(
                    icon: "eye",
                    text: viewersText(),
                    color: viewersColor()
                )
            }
            Spacer()
        }
    }
}
