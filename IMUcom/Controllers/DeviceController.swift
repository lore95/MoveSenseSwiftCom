import Foundation
import CoreBluetooth

class DeviceManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = DeviceManager()
    let dataProcessor = DataManipulationController()

    private var centralManager: CBCentralManager!
    private(set) var discoveredDevices: [CBPeripheral] = []
    @Published var pairedDevices: [CBPeripheral] = []
    
    let moveSenseServiceUUID = CBUUID(string: "34802252-7185-4d5d-b431-630e7050e8f0")
    private let GATTService = CBUUID(string: "34802252-7185-4d5d-b431-630e7050e8f0")

    
    @Published var isScanning = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // Start scanning
    func startScanning() {
        isScanning = true
        discoveredDevices.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    // Stop scanning
    func stopScanning() {
        isScanning = false
        centralManager.stopScan()
    }
    
    func connect(to peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
    }
    
    // CBCentralManager Delegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print("Bluetooth is not enabled.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if !discoveredDevices.contains(peripheral) {
            discoveredDevices.append(peripheral)
            objectWillChange.send()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        pairedDevices.append(peripheral)
        objectWillChange.send()
        peripheral.discoverServices(nil)
        central.scanForPeripherals(withServices: [GATTService], options: nil)
    
        print("Connected to \(peripheral.name ?? "Unknown Device")")
    }
}
