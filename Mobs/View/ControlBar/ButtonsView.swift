//
//  ButtonsView.swift
//  Mobs
//
//  Created by Erik Moqvist on 2023-08-31.
//

import SwiftUI

struct ButtonImage: View {
    var image: String
    var on: Bool = false
    
    var body: some View {
        let image = Image(systemName: image)
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(Circle())
        if on {
            image.overlay(
                Circle()
                    .stroke(.white)
            )
        } else {
            image
        }
    }
}

struct ButtonPlaceholderImage: View {
    var body: some View {
        Image(systemName: "pawprint")
            .frame(width: 40, height: 40)
            .foregroundColor(.black)
    }
}

struct GenericButton: View {
    @State private var image: String
    private var imageOn: String
    private var imageOff: String
    private var actionOn: () -> Void
    private var actionOff: () -> Void
    private var on: Bool = false

    init(imageOn: String, imageOff: String, actionOn: @escaping () -> Void, actionOff: @escaping () -> Void) {
        self.imageOn = imageOn
        self.imageOff = imageOff
        self.actionOn = actionOn
        self.actionOff = actionOff
        self.image = imageOff
    }
    
    var body: some View {
        Button(action: {
            if image == imageOn {
                image = imageOff
                actionOff()
            } else {
                image = imageOn
                actionOn()
            }
        }, label: {
            ButtonImage(image: image, on: image == imageOn)
        })
    }
}

struct RowIndex: Identifiable {
    var id: Int
}

struct ButtonsView: View {
    @ObservedObject var model: Model
    private var rowIndexes: [RowIndex]
    
    init(model: Model) {
        self.model = model
        self.rowIndexes = (0..<(model.database.buttons.count + 1) / 2).map({i in RowIndex(id: i)}).reversed()
    }
    
    func buildButton(index: Int) -> GenericButton {
        let button = model.database.buttons[index]
        switch button.type {
        case "Torch":
            return GenericButton(imageOn: button.systemImageNameOn,
                                 imageOff: button.systemImageNameOff,
                                 actionOn: {
                                     model.toggleLight()
                                 },
                                 actionOff: {
                                     model.toggleLight()
                                 })
        case "Mute":
            return GenericButton(imageOn: button.systemImageNameOn,
                                 imageOff: button.systemImageNameOff,
                                 actionOn: {
                                     model.toggleMute()
                                 },
                                 actionOff: {
                                     model.toggleMute()
                                 })
        case "Widget":
            return GenericButton(imageOn: button.systemImageNameOn,
                                 imageOff: button.systemImageNameOff,
                                 actionOn: {
                                     model.movieEffectOn()
                                 },
                                 actionOff: {
                                     model.movieEffectOff()
                                 })
        default:
            fatalError("Should never be executed")
        }
    }
    
    var body: some View {
        VStack {
            ForEach(rowIndexes) { rowIndex in
                HStack {
                    let evenNumberOfRows = ((rowIndex.id + 1) * 2 <= model.database.buttons.count)
                    if evenNumberOfRows {
                        buildButton(index: 2 * rowIndex.id + 1)
                        buildButton(index: 2 * rowIndex.id)
                    } else {
                        ButtonPlaceholderImage()
                        buildButton(index: 2 * rowIndex.id)
                    }
                }
            }
        }
    }
}
