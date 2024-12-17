import SwiftUI

struct MainView: View {
    @ObservedObject var deviceManager = DeviceManager.shared
    @State private var isSearching = false
    @State private var animateImage = false
    @State private var showFoundDevices = false
    @State private var searchStatusMessage = "Search for devices"
    @State private var showNoDeviceFound = false
    @State private var showResults = false

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top Half: Image Centered
                ZStack {
                    Image("movesenseIcon")
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                           .frame(
                               width: animateImage ? 360 : 280,
                               height: animateImage ? 360 : 280
                           )
                           .clipShape(Circle())
                           .rotationEffect(.degrees(animateImage ? 360 : 0)) // Continuous rotation
                           .animation(
                               animateImage
                                   ? Animation.linear(duration: 2.0).repeatForever(autoreverses: false)
                                   : .default, // Reset animation
                               value: animateImage
                           )
                           .animation(
                               animateImage
                                   ?         Animation.spring(response: 1.0, dampingFraction: 0.5, blendDuration: 0)
                                   : .default, // Reset animation
                               value: animateImage
                           )
                }
                .frame(height: geometry.size.height * 2 / 3) // Fixed 2/3 screen height
                .frame(maxWidth: .infinity) // Center the ZStack horizontally
                .onTapGesture {
                    startSearch()
                }
                .disabled(isSearching)

                // Bottom Part: Status Messages
                VStack {
                    if showNoDeviceFound {
                        Text("No device Found")
                            .font(Font.custom("Montserrat-Bold", size: 15))
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)
                    }
                    Text(searchStatusMessage)
                        .font(Font.custom("Montserrat-Bold", size: 20))
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                    Button("Results") {
                        showResults = true
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height / 3) // Fixed bottom 1/3 height
                .background(Color.clear)
            }
            .sheet(isPresented: $showFoundDevices, onDismiss: {
                deviceManager.disconnectAllDevices()
            }) {
                FoundDevicesView(onDeviceSelected: stopSearch)
            }
            .sheet(isPresented: $showResults) {
                ResultsView()
            }
        }
    }

    // MARK: - Start Scanning
    private func startSearch() {
        isSearching = true
        animateImage = true
        searchStatusMessage = "Looking for devices..."
        showNoDeviceFound = false
        deviceManager.startScanning()

        DispatchQueue.global().async {
            let startTime = Date()
            while isSearching {
                DispatchQueue.main.async {
                    if !deviceManager.discoveredDevices.isEmpty {
                        showFoundDevices = true
                    } else if Date().timeIntervalSince(startTime) >= 10 {
                        if deviceManager.discoveredDevices.isEmpty
                        {
                            showNoDeviceFound = true
                        }
                        stopSearch()
                    }
                }
                sleep(1)
            }
        }
    }

    private func stopSearch() {
        isSearching = false
        animateImage = false
        searchStatusMessage = "Search for devices"
        deviceManager.stopScanning()
    }
}
