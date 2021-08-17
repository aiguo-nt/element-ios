//
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

@available(iOS 14.0.0, *)
struct RoomNotificationSettings: View {
    
    @Environment(\.theme) var theme: Theme
    @ObservedObject var viewModel: RoomNotificationSettingsViewModel
    
    let presentedModally: Bool
    
    @ViewBuilder
    private var leftButton: some View {
        if presentedModally {
            Button(VectorL10n.cancel) {
                viewModel.process(viewAction: .cancel)
            }
        }
    }
    
    @ViewBuilder
    private var rightButton: some View {
        Button(VectorL10n.save) {
            viewModel.process(viewAction: .save)
        }
    }
    
    var body: some View {
        VectorForm {
            if case let .swiftUI(avatarData) = viewModel.viewState.avatarData {
                RoomNotificationSettingsHeader(
                    avatarData: avatarData,
                    displayName: viewModel.viewState.displayName
                )
            }
            SwiftUI.Section(
                header: FormSectionHeader(text: VectorL10n.roomNotifsSettingsNotifyMeFor),
                footer: FormSectionFooter(text: viewModel.viewState.roomEncryptedString)
            ) {
                ForEach(viewModel.viewState.notificationOptions) { option in
                    FormPickerItem(title: option.title, selected: viewModel.viewState.notificationState == option) {
                        viewModel.process(viewAction: .selectNotificationState(option))
                    }
                }
            }
            .navigationBarTitle(VectorL10n.roomDetailsNotifs)
            .navigationBarItems(
                leading: leftButton,
                trailing: rightButton
            )
            .onAppear {
                viewModel.process(viewAction: .load)
            }
        }
    }
}

@available(iOS 14.0, *)
struct RoomNotificationSettings_Previews: PreviewProvider {
    
    static let mockViewModel = RoomNotificationSettingsViewModel(
        roomNotificationService: MockRoomNotificationSettingsService.example,
        avatarData: .swiftUI(MockAvatarInput.example),
        displayName: MockAvatarInput.example.displayName,
        roomEncrypted: true
    )
    
    static var previews: some View {
        Group {
            NavigationView {
                RoomNotificationSettings(viewModel: mockViewModel, presentedModally: true)
                    .navigationBarTitleDisplayMode(.inline)
                    .addDependency(MockAvatarService.example)
            }
            NavigationView {
                RoomNotificationSettings(viewModel: mockViewModel, presentedModally: true)
                    .navigationBarTitleDisplayMode(.inline)
                    .addDependency(MockAvatarService.example)
                    .theme(ThemeIdentifier.dark)
            }
        }
    }
}
