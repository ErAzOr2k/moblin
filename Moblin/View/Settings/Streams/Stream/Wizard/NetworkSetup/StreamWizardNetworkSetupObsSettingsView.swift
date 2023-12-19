import SwiftUI

struct StreamWizardNetworkSetupObsSettingsView: View {
    @EnvironmentObject private var model: Model

    private func isDisabled() -> Bool {
        return model.wizardObsAddress.isEmpty || model.wizardObsPort.isEmpty
    }

    var body: some View {
        Form {
            Section {
                TextField("213.33.45.132", text: $model.wizardObsAddress)
                    .disableAutocorrection(true)
            } header: {
                Text("IP address or domain name")
            }
            Section {
                TextField("7000", text: $model.wizardObsPort)
                    .disableAutocorrection(true)
            } header: {
                Text("Port")
            }
            Section {
                NavigationLink(destination: StreamWizardGeneralSettingsView()) {
                    WizardNextButtonView()
                }
                .disabled(isDisabled())
            }
        }
        .onAppear {
            model.wizardNetworkSetup = .obs
        }
        .navigationTitle("OBS")
        .toolbar {
            CreateStreamWizardToolbar()
        }
    }
}
