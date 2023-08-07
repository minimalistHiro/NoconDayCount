//
//  ContentView.swift
//  NoconDayCount
//
//  Created by 金子広樹 on 2023/08/06.
//

import SwiftUI

struct ContentView: View {
    let setting = Setting()
    
    // 本日の日付
    @State private var today = Date()
    @State private var dateText = ""
    private let dateFormatter = DateFormatter()
    // 時間、分、秒取得
    @State private var hour = Calendar.current.component(.hour, from: Date())
    @State private var minute = Calendar.current.component(.minute, from: Date())
    @State private var second = Calendar.current.component(.second, from: Date())
    
    // セットするデータ
    @AppStorage("setText") private var setText: String = "テキスト"   // テキスト
    @AppStorage("setYear") private var setYear: Int = 2023          // 年
    @AppStorage("setMonth") private var setMonth: Int = 12          // 月
    @AppStorage("setDay") private var setDay: Int = 31              // 日
    
    @State private var remainingDate = Date()       // 残り時間
    @State private var remainingDay: Int = 0        // 残りの日数
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    @State private var isShowSheet: Bool = false    // シートの表示有無
    
    // 各種時間表示テキストを1桁ずつ分ける
    var hourTensPlace: String {
        let number = String(format: "%02d", hour)
        return String(number.dropLast())
    }           // 時間の10の位
    var hourOnesPlace: String {
        let number = String(format: "%02d", hour)
        return String(number.dropFirst())
    }           // 時間の1の位
    var minutesTensPlace: String {
        let number = String(format: "%02d", minute)
        return String(number.dropLast())
    }           // 分の10の位
    var minutesOnesPlace: String {
        let number = String(format: "%02d", minute)
        return String(number.dropFirst())
    }           // 分の1の位
    var secondTensPlace: String {
        let number = String(format: "%02d", second)
        return String(number.dropLast())
    }           // 秒の10の位
    var secondOnesPlace: String {
        let number = String(format: "%02d", second)
        return String(number.dropFirst())
    }           // 秒の1の位
    
    // 各種サイズ
    let timerLabelFrameWidth: CGFloat = 30          // 時間表示テキストのフレーム横幅
    
    init() {
        dateFormatter.dateFormat = "dd"
        dateFormatter.locale = Locale(identifier: "ja_jp")
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            Spacer()
            
            Text(setText)
                .font(.system(size: 30))
                .padding(.bottom)
            Text("\(String(setYear))/\(setMonth)/\(setDay)")
                .font(.system(size: 30))
            Image(systemName: "chevron.down")
                .resizable()
                .scaledToFit()
                .frame(width: 25)
            
            Spacer()
            
            if remainingDay < 0 {
                Text("既に経過しています")
                    .font(.system(size: 35))
            } else {
                HStack(alignment: .bottom) {
                    Text("\(remainingDay)")
                        .font(.system(size: 70))
                        .bold()
                    Text("日")
                        .font(.system(size: 40))
                }
                HStack {
                    Text(hourTensPlace)
                        .frame(width: timerLabelFrameWidth, alignment: .trailing)
                    Text(hourOnesPlace)
                        .frame(width: timerLabelFrameWidth, alignment: .trailing)
                    Text(":")
                    Text(minutesTensPlace)
                        .frame(width: timerLabelFrameWidth, alignment: .trailing)
                    Text(minutesOnesPlace)
                        .frame(width: timerLabelFrameWidth, alignment: .trailing)
                    Text(":")
                    Text(secondTensPlace)
                        .frame(width: timerLabelFrameWidth, alignment: .trailing)
                    Text(secondOnesPlace)
                        .frame(width: timerLabelFrameWidth, alignment: .trailing)
                }
                .font(.system(size: 40))
            }
            
            Spacer()
            
            Button {
                isShowSheet = true
            } label: {
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .foregroundColor(setting.black)
                    .overlay {
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                            .bold()
                            .foregroundColor(setting.white)
                    }
            }
            .padding()
        }
        .sheet(isPresented: $isShowSheet) {
            SheetView(setText: $setText, setYear: $setYear, setMonth: $setMonth, setDay: $setDay, isShowSheet: $isShowSheet)
        }
        .onReceive(timer) { _ in
            self.remainingDate = dateCalculation()
            dateText = "\(dateFormatter.string(from: remainingDate))"
            self.hour = Calendar.current.component(.hour, from: remainingDate)
            self.minute = Calendar.current.component(.minute, from: remainingDate)
            self.second = Calendar.current.component(.second, from: remainingDate)
        }
    }
    
    /// 現在の日付と設定した日付の差分の日付を計算。
    /// - Parameters: なし
    /// - Returns: なし
    private func dateCalculation() -> Date {
        let calendar = Calendar(identifier: .gregorian)

        let setDate = calendar.date(from: DateComponents(year: setYear, month: setMonth, day: setDay, hour: 0, minute: 0, second: 0))

        let todayDate = Date()
        
        let progressDC = calendar.dateComponents([.day, .hour, .minute, .second], from: todayDate, to: setDate!)
        remainingDay = calendar.dateComponents([.day], from: todayDate, to: setDate!).day!
        let progressDate = calendar.date(from: progressDC)

        return progressDate ?? Date()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
