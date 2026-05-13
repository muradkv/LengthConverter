//
//  ContentView.swift
//  LengthConverter
//
//  Created by murad on 13.05.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText = ""
    @State private var inputUnit = UnitLength.meters
    @State private var outputUnit = UnitLength.kilometers
    @FocusState private var amountIsFocused: Bool
    
    // Converts the input string to a Double using the locale-aware formatter
    private var inputValue: Double {
        let number = numberFormatter.number(from: inputText)
            return number?.doubleValue ?? 0
    }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // Allows decimal numbers
        formatter.locale = Locale.current // Respects user's region (e.g., "." or ",")
        formatter.maximumFractionDigits = 10
        return formatter
    }()
    
    private let units: [UnitLength] = [.meters, .kilometers, .feet, .yards, .miles]
    
    private var convert: String {
        let measurement = Measurement(value: inputValue, unit: inputUnit)
        let convertedValue = measurement.converted(to: outputUnit)
        let formattedValue = convertedValue.value.formatted(.number.precision(.fractionLength(3)))
        
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long
        let unitName = formatter.string(from: convertedValue.unit)
        
        return "\(formattedValue) \(unitName)"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Enter amount") {
                    TextField("Value", text: $inputText)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                }
                
                Section("Converting from") {
                    Picker("Input unit", selection: $inputUnit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit.symbol).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Converting to") {
                    Picker("Output unit", selection: $outputUnit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit.symbol).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Here you go!") {
                    Text(convert)
                }
            }
            .navigationTitle("Length Converter")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
