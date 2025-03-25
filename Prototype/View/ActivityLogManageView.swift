//
//  ActivityLogView.swift
//  Prototype
//
//  Created by 최낙주 on 3/23/25.
//

import SwiftUI

struct ActivityLogManageView: View {
    @StateObject var activityLogManageViewModel = ActivityLogManageViewModel()
    @StateObject var activityLogViewModel: ActivityLogViewModel
    @State var isCreateMode: Bool = true
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            CustomNavigationBar(
                leftBtnAction: {
                    dismiss()
                },
                rightBtnAction: {
                    if isCreateMode && activityLogViewModel.activityLog.content.isEmpty {
                        activityLogManageViewModel.addActivityLog(activityLogViewModel.activityLog)
                        isCreateMode.toggle()
                    } else {
                        activityLogManageViewModel.updateActivityLog(activityLogViewModel.activityLog)
                    }
                },
                rightBtnType: isCreateMode ? .create : .complete)
            
            TitleView()
                .environmentObject(activityLogManageViewModel)
                .padding(.leading, 20)
            
            CalendarView(isCreateMode: $isCreateMode)
                .environmentObject(activityLogManageViewModel)
                .padding(.leading, 20)
            
            ContentView(
                activityLogviewModel: activityLogViewModel,
                isCreateMode: $isCreateMode
            )
            .environmentObject(activityLogManageViewModel)
            .environmentObject(activityLogViewModel)
        }
    }
}

private struct TitleView: View {
    @EnvironmentObject private var activityLogviewModel: ActivityLogManageViewModel
    
    var body: some View {
        Text("\(activityLogviewModel.selectedDate.formattedDateString)")
            .font(.system(size: 30, weight: .bold))
            .padding(.top, 20)
    }
}

private struct CalendarView: View {
    @EnvironmentObject private var activityLogManageViewModel: ActivityLogManageViewModel
    @Binding var isCreateMode: Bool
    
    fileprivate init(isCreateMode: Binding<Bool>) {
        self._isCreateMode = isCreateMode
    }
    
    var body: some View {
        Button {
            activityLogManageViewModel.setIsCalendarDisplay(true)
        } label: {
            Text("활동 날짜 선택하기")
                .font(.system(size: 16, weight: .bold))
        }
        .popover(isPresented: $activityLogManageViewModel.isCalendarDisplay) {
            DatePicker(
                "",
                selection: $activityLogManageViewModel.selectedDate,
                displayedComponents: .date
            )
            .labelsHidden()
            .datePickerStyle(GraphicalDatePickerStyle())
            .frame(maxWidth: .infinity, alignment: .center)
            .onChange(of: activityLogManageViewModel.selectedDate) { _ in
                activityLogManageViewModel.setIsCalendarDisplay(false)
                if activityLogManageViewModel.selectedDateContent.isEmpty {
                    isCreateMode = true
                } else {
                    isCreateMode = false
                }
            }
        }
    }
}

private struct ContentView: View {
    @ObservedObject private var activityLogviewModel: ActivityLogViewModel
    @EnvironmentObject private var activityLogManageViewModel: ActivityLogManageViewModel
    @FocusState private var isContentFocused: Bool
    @Binding private var isCreateMode: Bool
    
    fileprivate init(
        activityLogviewModel: ActivityLogViewModel,
        isCreateMode: Binding<Bool>
    ) {
        self.activityLogviewModel = activityLogviewModel
        self._isCreateMode = isCreateMode
    }
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundStyle(.secondary)
                .opacity(0.5)
                .frame(height: 1)
                .padding(.leading, 10)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $activityLogManageViewModel.selectedDateContent)
                    .font(.system(size: 20))
                    .focused($isContentFocused)
                    .onAppear {
                        if isCreateMode {
                            isContentFocused = true
                        }
                    }
                    .onChange(of: activityLogManageViewModel.selectedDate) { _ in
                        activityLogManageViewModel.getActivityLog()
                    }
                
                if activityLogManageViewModel.selectedDateContent.isEmpty {
                    Text("활동 내용을 입력해주세요.")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.gray)
                        .allowsHitTesting(false)
                        .padding(.top, 10)
                        .padding(.leading, 3)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ActivityLogManageView(activityLogViewModel: .init(activityLog: .init(id: UUID(), content: "")))
}
