import SwiftUI

struct PlotAndSaveView: View {
    @ObservedObject var dataModel: DataAquisitionModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Recorded Data Plot")
                .font(.title)
                .bold()
                .padding(.top, 20)

            // Data Plot View
            DataPlotView(dataPoints: dataModel.angleDataPoints)
                .frame(width: 300, height: 200)
                .border(Color.gray, width: 1)
                .padding()

            Spacer()

            // Buttons: Save and Close
            HStack(spacing: 20) {
                Button(action: {
                    dataModel.isToSave = true
                    dataModel.stopRecording()
                    presentationMode.wrappedValue.dismiss()

                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                }

                Button(action: {
                    dataModel.stopRecording()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            .padding(.bottom, 30)
        }
        .padding()
    }
}
