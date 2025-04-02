//
//  ContentView.swift
//  Prototype
//
//  Created by 최낙주 on 3/16/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @StateObject private var activityLogViewModel = ActivityLogManageViewModel()
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TimeProgressView()
                
                StartButtonView()
                
                Spacer()
                GotoActivityLogView()
                
//                TextView()
            }
            .environmentObject(locationManager)
            .environmentObject(activityLogViewModel)
            .padding()
        }
    }
}

private struct TimeProgressView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @State private var elapsedMinutes: Int = 0
    @State private var isTimerRunning: Bool = false
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text("\(elapsedMinutes / 60)시간 \(String(format: "%02d", elapsedMinutes % 60))분")
            .font(.largeTitle)
            .onAppear {
                updateElapsedMinutes()
                isTimerRunning = viewModel.isStarted
            }
            .onReceive(timer) { _ in
                if isTimerRunning {
                    updateElapsedMinutes()
                }
            }
            .onChange(of: viewModel.isStarted) { newValue in
                if newValue {
                    updateElapsedMinutes()
                    isTimerRunning = true
                } else {
                    isTimerRunning = false
                }
            }
    }
    
    private func updateElapsedMinutes() {
        if let startDate = viewModel.startDate {
            let interval = Date().timeIntervalSince(startDate)
            elapsedMinutes = Int(interval) / 60
        }
    }
}

private struct StartButtonView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @EnvironmentObject private var locationManager: LocationManager
    @State private var isDisabled: Bool = false
    private let startHour = 6
    private let endHour = 22
    private let lastUsedDateKey = "lastUsedDate"
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                viewModel.setIsDisplayAlert(true)
            } label: {
                Text(viewModel.isStarted ? "종료" : "시작")
            }
            .alert(
                viewModel.isStarted
                ? "종료하시겠습니까?"
                : "시작하시겠습니까?",
                isPresented: $viewModel.isDisplayAlert
            ) {
                Button("예", role: .cancel) {
                    viewModel.saveDate()
                    locationManager.checkLocationAuthorization()
                    locationManager.reverseGeocoding(
                        locationManager.address.latitude,
                        locationManager.address.longitude
                    )
                    
                    if !viewModel.isStarted {
                        saveLastUsedDate()
                        checkButtonStatus()
                    }
                }
                Button("아니오", role: .destructive) { }
            }
            .disabled(isDisabled)
            .padding()
            .background(isDisabled ? Color.gray : Color.blue)
            .foregroundStyle(Color.white)
            .cornerRadius(10)
        }
        .onAppear {
            checkButtonStatus() // 화면이 나타날 떄 상태 업데이트
        }
        .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
            checkButtonStatus() // 1분마다 시간 체크
        }
        
        Text("시작 가능 시간 06:00 - 22:00")
            .font(.headline)
    }
    
    private func checkButtonStatus() {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let lastUsedDate = getLastUsedDate()
        
        let isTimeRestricted = currentHour < startHour || currentHour >= endHour
        let isSameDay = isSameDate(lastUsedDate, Date())
        isDisabled = isTimeRestricted || isSameDay
    }
    
    // 마지막으로 버튼을 사용한 날짜를 UserDafaults에 저장
    private func saveLastUsedDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: Date())
        UserDefaults.standard.set(todayString, forKey: lastUsedDateKey)
    }
    
    // UserDafaults에서 마지막으로 버튼을 사용한 날짜 가져오기
    private func getLastUsedDate() -> Date? {
        if let dateString = UserDefaults.standard.string(forKey: lastUsedDateKey) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.date(from: dateString)
        }
        return nil
    }
    
    // 두 날짜가 같은 날인지 비교
    private func isSameDate(_ date1: Date?, _ date2: Date) -> Bool {
        guard let date1 = date1 else { return false }
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

private struct TextView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @EnvironmentObject private var locationManager: LocationManager
    
    var body: some View {
        VStack {
            if viewModel.isStarted {
                if let startDate = viewModel.startDate {
                    Text("현재 계신 위치 : \(locationManager.address.roadAddress)")
                    Text("시작 시간 : \(startDate.formattedDateAndTimeString)")
                }
            } else {
                if let finishDate = viewModel.finishDate {
                    Text("현재 계신 위치 : \(locationManager.address.roadAddress)")
                    Text("종료 시간 : \(finishDate.formattedDateAndTimeString)")
                }
            }
        }
    }
}

private struct GotoActivityLogView: View {
    @EnvironmentObject var activityLogManageViewModel: ActivityLogManageViewModel
    
    var body: some View {
        NavigationLink {
            ActivityLogManageView(
                activityLogViewModel: .init(
                    activityLog: .init(id: UUID(), content: "")
                )
            )
            .environmentObject(activityLogManageViewModel)
            .navigationBarBackButtonHidden()
        } label: {
            Text("활동 일지 관리하기")
        }
        .buttonStyle(.borderedProminent)

    }
}

struct Content_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ViewModel())
            .environmentObject(ActivityLogManageViewModel())
    }
}
