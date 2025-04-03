//
//  PhoneAuthViewModel.swift
//  Prototype
//
//  Created by 최낙주 on 3/19/25.
//

import Foundation
import FirebaseAuth
import Combine

class PhoneAuthViewModel: ObservableObject {
    
    let network: NetworkService
    @Published var user: User?
    
    @Published var phoneNumber: String = ""
    @Published var verificationId: String?
    @Published var verificationCode: String = ""
    @Published var isVerified = false
    @Published var errorMessage: String?
    
    init(network: NetworkService) {
        self.network = network
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    func fetchPhoneNumber() {
        let resource: Resource<User> = Resource(
            base: APIInfo.baseURL,
            path: "users/\(phoneNumber)",
            params: [:],
            header: [:]
        )
        
        network.load(resource)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }.store(in: &subscriptions)
    }
    
    // 전화번호로 인증 코드 요청
    func sendCode() {
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false // 테스트 모드 비활성화
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationId, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.verificationId = verificationId
        }
    }
    
    // 인증 코드 입력 후 확인
    func verifyCode() {
        guard let verificationId = verificationId else { return }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.isVerified = true
            
        }
    }
    
    func saveUserId() {
        if let user = Auth.auth().currentUser {
            UserDefaults.standard.setValue(user.uid, forKey: "user_id")
        }
    }
}
