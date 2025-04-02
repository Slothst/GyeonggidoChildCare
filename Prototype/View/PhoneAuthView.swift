//
//  PhoneAuthView.swift
//  Prototype
//
//  Created by 최낙주 on 3/20/25.
//

import SwiftUI
import Combine

struct PhoneAuthView: View {
    @StateObject private var phoneAuthViewModel = PhoneAuthViewModel(network: .init(configuration: .default))
    @State private var showAlert = false
    @State private var navigateToContentView = false
    
    var subscriptions = Set<AnyCancellable>()
    var user: User?
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("전화번호 입력 (+821012345678)", text: $phoneAuthViewModel.phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("인증 코드 받기") {
                    phoneAuthViewModel.checkIsValidPhoneNumber()
                    
                    if phoneAuthViewModel.user != nil {
                        phoneAuthViewModel.sendCode()
                    }
                }
                .disabled(phoneAuthViewModel.phoneNumber.isEmpty)
                
                if phoneAuthViewModel.verificationId != nil {
                    TextField("인증 코드 입력", text: $phoneAuthViewModel.verificationCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("코드 확인") {
                        phoneAuthViewModel.verifyCode()
                    }
                    .disabled(phoneAuthViewModel.verificationCode.count != 6)
                    .padding()
                }
                
                if let errorMessage = phoneAuthViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(Color.red)
                }
                
                Spacer()
            }
            .onChange(of: phoneAuthViewModel.isVerified) { newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        showAlert = true
                    }
                }
            }
            .alert("인증 성공", isPresented: $showAlert) {
                Button("확인") {
                    phoneAuthViewModel.saveUserId()
                    navigateToContentView = true
                }
            } message: {
                Text("휴대폰 인증이 완료되었습니다.")
            }
            .background(
                Group {
                    if navigateToContentView {
                        if let user = phoneAuthViewModel.user {
                            NavigationLink(
                                destination: MainView()
                                    .environmentObject(ViewModel())
                                    .environmentObject(UserViewModel(user: user))
                                    .navigationBarBackButtonHidden(),
                                isActive: $navigateToContentView,
                                label: {
                                    EmptyView()
                                })
                            .hidden()
                        }
                    }
                }
            )
        }
    }
}

struct PhoneAuthView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAuthView()
    }
}
