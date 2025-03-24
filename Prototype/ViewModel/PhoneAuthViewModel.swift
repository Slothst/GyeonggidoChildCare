//
//  PhoneAuthViewModel.swift
//  Prototype
//
//  Created by 최낙주 on 3/19/25.
//

import Foundation
import FirebaseAuth

class PhoneAuthViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var verificationId: String?
    @Published var verificationCode: String = ""
    @Published var isVerified = false
    @Published var errorMessage: String?
    
    
    
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
            
            if let user = Auth.auth().currentUser {
                UserDefaults.standard.setValue(user.uid, forKey: "user_id")
            }
        }
        
    }
}
