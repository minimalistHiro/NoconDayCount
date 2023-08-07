//
//  SheetView.swift
//  NoconDayCount
//
//  Created by 金子広樹 on 2023/08/06.
//

import SwiftUI

struct SheetView: View {
    let setting = Setting()
    
    // セットするデータ
    @Binding var setText: String
    @Binding var setYear: Int
    @Binding var setMonth: Int
    @Binding var setDay: Int
    
    @Binding var isShowSheet: Bool
    
    @State private var text: String = ""                // 入力テキスト
    @State private var selectionDate = Date()           // 入力日付
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("タイトル", text: $text)
                DatePicker("", selection: $selectionDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
            }
            .overlay {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            updateSetDate()
                            isShowSheet = false
                        } label: {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .foregroundColor(setting.black)
                                .overlay {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20)
                                        .bold()
                                        .foregroundColor(setting.white)
                                }
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    /// セットするデータを更新する。
    /// - Parameters: なし
    /// - Returns: なし
    private func updateSetDate() {
        // 入力日付から"年"、"月"、"日"を取得。
        let year = Calendar.current.component(.year, from: selectionDate)
        let month = Calendar.current.component(.month, from: selectionDate)
        let day = Calendar.current.component(.day, from: selectionDate)
        
        // 各項目をDBにセット。
        setText = text
        setYear = year
        setMonth = month
        setDay = day
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(setText: .constant("テキスト"),
                  setYear: .constant(2030),
                  setMonth: .constant(12),
                  setDay: .constant(31),
                  isShowSheet: .constant(true))
    }
}
