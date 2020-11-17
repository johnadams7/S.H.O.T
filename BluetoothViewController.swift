//
//  BluetoothViewController.swift
//  S.H.O.T.
//
//  Created by John Adams on 11/7/20.
//

import UIKit
import CoreBluetooth

let amuXCBUUID = CBUUID(string: "2101")
let amuYCBUUID = CBUUID(string: "2102")
let amuZCBUUID = CBUUID(string: "2103")
let shotCBUUID = CBUUID(string: "2104")

var Xs = [Float]()
var Ys = [Float]()
var Zs = [Float]()
var shots = [String]()

class BluetoothViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var count = 0
    
    var centralManager: CBCentralManager!
    var myPeripheral: CBPeripheral!
    
    
    func showConnectionAlert() {
        let alert = UIAlertController(title: "Connected!", message: "You are now connected to 'Arduino Gyro'.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in print("tapped dismiss")}))
        
        present(alert, animated: true)
    }
    func showConnectionFailedAlert() {
        let alert = UIAlertController(title: "Connection Failed", message: "Could not connect to 'Arduino Gyro'. Make sure the device is turned on and in range, then try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in print("tapped dismiss")}))
        
        present(alert, animated: true)
    }
    
    //@IBAction func didTapButton(){
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            print("BLE powered on")
            //Turned on
            central.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            print("Something went wrong with the BLE")
            //Not on, but can have different issues
        }
    }
   // @IBOutlet var countDownLabel: UILabel!
    
  //  var count = 10
    
 // @IBAction func didTapButton(){
        
        
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
     
        if let pname = peripheral.name{
           // print(pname)
            if pname == "Arduino"{
                self.centralManager.stopScan()
                self.myPeripheral = peripheral
                self.myPeripheral.delegate = self
                //print(peripheral)
                self.centralManager.connect(peripheral, options: nil)
                showConnectionAlert()
            }
          }
        }
  //  }
  
 
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.myPeripheral.discoverServices(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
    }
    
    
    
}

extension BluetoothViewController{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else {return}
        
        for service in services{
            print(service)
            peripheral.discoverCharacteristics(nil, for:service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
        
        guard let characteristics = service.characteristics else {return}
        
        for characteristic in characteristics{
            print(characteristic)
            
            if characteristic.properties.contains(.read){
                print("\(characteristic.uuid): properties contains .read")
            }
            if characteristic.properties.contains(.notify){
                print("\(characteristic.uuid): properties contains .notify")
            }
            peripheral.setNotifyValue(true, for: characteristic)
            peripheral.readValue(for: characteristic)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        
       
        
        switch characteristic.uuid{
        case amuXCBUUID:
            print(characteristic.value ?? "X: no value")
            print(characteristic.value![0])
            Xs.append(Float(characteristic.value![0]))
           // print(globalX)
        case amuYCBUUID:
            print(characteristic.value ?? "Y: no value")
            print(characteristic.value![0])
            Ys.append(Float(characteristic.value![0]))
            //print(globalY)
        case amuZCBUUID:
            print(characteristic.value ?? "Z: no value")
            print(characteristic.value![0])
            Zs.append(Float(characteristic.value![0]))
            count+=1
            print(count)
         //   print(globalZ)
//            print(characteristic.value![1])
//            print(characteristic.value![2])
//            print(characteristic.value![3])
        case shotCBUUID:
            print(characteristic.value ?? "Shot information not found")
            print(characteristic.value![0])
            shots.append(String(characteristic.value![0]))
            
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
            
            
        }
    }
    
}

