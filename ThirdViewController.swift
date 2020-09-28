//
//  ThirdViewController.swift
//  S.H.O.T. v2
//
//  Created by John Adams on 9/8/20.
//  Copyright © 2020 John Adams. All rights reserved.
//


import UIKit
import Foundation
import CoreBluetooth


class ThirdViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    var manager: CBCentralManager!
    
    let scanningDelay = 1.0
    var items = [String: [String: Any]]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Bluetooth"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.keys.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        // Configure the cell...
        if let item = itemForIndexPath(indexPath){
            cell.textLabel?.text = item["name"] as? String
            
            if let rssi = item["rssi"] as? Int {
                cell.detailTextLabel?.text = "\(rssi.description) dBm"
            } else {
                cell.detailTextLabel?.text = ""
            }
        }
        
        return cell
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> [String: Any]?{
        
        if indexPath.row > items.keys.count{
            return nil
        }
        
        return Array(items.values)[indexPath.row]
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        if central.state == .poweredOn{
            manager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        
        didReadPeripheral(peripheral, rssi: RSSI)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        
        didReadPeripheral(peripheral, rssi: RSSI)
        
        delay(scanningDelay){
            peripheral.readRSSI()
        }
    }
    
    func didReadPeripheral(_ peripheral: CBPeripheral, rssi: NSNumber){
        
        if let name = peripheral.name{
            
            items[name] = [
                "name":name,
                "rssi":rssi
            ]
        }
        tableView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        peripheral.readRSSI()
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
/*import Foundation
import CoreBluetooth

let btDiscoverySharedInstance = BTDiscovery();

class BTDiscovery: NSObject, CBCentralManagerDelegate {
  
  fileprivate var centralManager: CBCentralManager?
  fileprivate var peripheralBLE: CBPeripheral?
  
  override init() {
    super.init()
    
    let centralQueue = DispatchQueue(label: "com.raywenderlich", attributes: [])
    centralManager = CBCentralManager(delegate: self, queue: centralQueue)
  }
  
  func startScanning() {
    if let central = centralManager {
      central.scanForPeripherals(withServices: [BLEServiceUUID], options: nil)
    }
  }
  
  var bleService: BTService? {
    didSet {
      if let service = self.bleService {
        service.startDiscoveringServices()
      }
    }
  }
  
  // MARK: - CBCentralManagerDelegate
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    // Be sure to retain the peripheral or it will fail during connection.
    
    // Validate peripheral information
    if ((peripheral.name == nil) || (peripheral.name == "")) {
      return
    }
    
    // If not already connected to a peripheral, then connect to this one
    if ((self.peripheralBLE == nil) || (self.peripheralBLE?.state == CBPeripheralState.disconnected)) {
      // Retain the peripheral before trying to connect
      self.peripheralBLE = peripheral
      
      // Reset service
      self.bleService = nil
      
      // Connect to peripheral
      central.connect(peripheral, options: nil)
    }
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    
    // Create new service class
    if (peripheral == self.peripheralBLE) {
      self.bleService = BTService(initWithPeripheral: peripheral)
    }
    
    // Stop scanning for new devices
    central.stopScan()
  }
  
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    
    // See if it was our peripheral that disconnected
    if (peripheral == self.peripheralBLE) {
      self.bleService = nil;
      self.peripheralBLE = nil;
    }
    
    // Start scanning for new devices
    self.startScanning()
  }
  
  // MARK: - Private
  
  func clearDevices() {
    self.bleService = nil
    self.peripheralBLE = nil
  }
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch (central.state) {
    case .poweredOff:
      self.clearDevices()
      
    case .unauthorized:
      // Indicate to user that the iOS device does not support BLE.
      break
      
    case .unknown:
      // Wait for another event
      break
      
    case .poweredOn:
      self.startScanning()
      
    case .resetting:
      self.clearDevices()
      
    case .unsupported:
      break
    }
  }

}

*/

/*import CoreBluetooth
import UIKit
 
class ViewController: UIViewController {
var centralManager: CBCentralManager?
var peripherals = Array<CBPeripheral>()
 
@IBOutlet weak var tableView: UITableView!
 
override func viewDidLoad() {
super.viewDidLoad()
 
//Initialise CoreBluetooth Central Manager
centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
}
}
 
extension ViewController: CBCentralManagerDelegate {
func centralManagerDidUpdateState(_ central: CBCentralManager) {
if (central.state == .poweredOn){
self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
}
else {
// do something like alert the user that ble is not on
}
}
 
func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
peripherals.append(peripheral)
tableView.reloadData()
}
}
 
extension ViewController: UITableViewDataSource {
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
 
let peripheral = peripherals[indexPath.row]
cell.textLabel?.text = peripheral.name
 
return cell
}
 
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
return peripherals.count
}
}
*/


/*import UIKit
import CoreBluetooth

class ThirdViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate{

    var centralManager: CBCentralManager!
    var myPeripheral: CBPeripheral!

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            print("Bluetooth powered on")
            central.scanForPeripherals(withServices: nil, options: nil)
            //turned on
        }
        else{
            print("Something went wrong with Bluetooth")
            //not on, but can have different issues
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let pname = peripheral.name {
            print(pname)
          // if pname == ""{
            //    self.centralManager.stopScan()
              
              //  self.myPeripheral = peripheral
                //self.myPeripheral.delegate = self
                
              //  self.centralManager.connect(peripheral, options: nil)
            }
        }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.myPeripheral.discoverServices(nil)
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}*/
