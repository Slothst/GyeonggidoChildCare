//
//  ActivityLogView.swift
//  Prototype
//
//  Created by 최낙주 on 3/23/25.
//

import SwiftUI

struct ActivityLogView: View {
    @StateObject var viewModel = ActivityLogViewModel()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                TitleView()
                    .environmentObject(viewModel)
                    .padding(.leading, 20)
                
                CalendarView()
                    .environmentObject(viewModel)
                    .padding(.leading, 20)
    
                ContentView()
                    .environmentObject(viewModel)
            }
        }
    }
}

private struct TitleView: View {
    @EnvironmentObject private var activityLogviewModel: ActivityLogViewModel
    
    var body: some View {
        Text("\(activityLogviewModel.selectedDate.formattedDateString)")
            .font(.system(size: 30, weight: .bold))
            .padding(.top, 20)
    }
}

private struct CalendarView: View {
    @EnvironmentObject private var activityLogviewModel: ActivityLogViewModel
    
    var body: some View {
        Button {
            activityLogviewModel.setIsCalendarDisplay(true)
        } label: {
            Text("활동 날짜 선택하기")
                .font(.system(size: 16, weight: .bold))
        }
        .popover(isPresented: $activityLogviewModel.isCalendarDisplay) {
            DatePicker(
                "",
                selection: $activityLogviewModel.selectedDate,
                displayedComponents: .date
            )
            .labelsHidden()
            .datePickerStyle(GraphicalDatePickerStyle())
            .frame(maxWidth: .infinity, alignment: .center)
            .onChange(of: activityLogviewModel.selectedDate) { _ in
                activityLogviewModel.setIsCalendarDisplay(false)
            }
        }
    }
}

private struct ContentView: View {
    @EnvironmentObject private var activityLogviewModel: ActivityLogViewModel
    
    var body: some View {
        VStack {
            
            Rectangle()
                .foregroundStyle(.secondary)
                .opacity(0.5)
                .frame(height: 1)
                .padding(.leading, 10)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $activityLogviewModel.content)
                    .font(.system(size: 20))
                
                if activityLogviewModel.content.isEmpty {
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
    ActivityLogView()
}
