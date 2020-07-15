//
//  ViewController.swift
//  CustomDatePicker
//
//  Created by Bogdan on 14/7/20.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Variables
    private var appointmentDays = [AppointmentDay]()
    private var appointmentTimes = [AppointmentTime]()
    private var selectedDate = AppointmentDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getAvailableDates()
        createApointmentDatePicker()
        
        //print(apointment)
    }
    
    func createApointmentDatePicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func getAvailableDates() {
        activityIndicator.startAnimating()
        RESTful.request(path: "https://dovgopol.dev/api/testApi", method: "GET", parameters: nil, headers: nil) { [weak self] result in
            
            guard let self = self else {return}
            
            switch result {
            
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    self.appointmentDays = try decoder.decode([AppointmentDay].self, from: data)
                    DispatchQueue.main.async {
                        self.pickerView.reloadAllComponents()
                    }
                } catch(let error) {
                    debugPrint(error)
                }
            case .failure(let error):
                debugPrint(error)
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    
    @IBAction func onShowPressed(_ sender: Any) {
        print(selectedDate)
    }
    
}

//MARK: Custom UIPickerView
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return appointmentDays.count
        case 1:
            return appointmentTimes.count
        default:
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            selectedDate.day = appointmentDays[row].day
            appointmentTimes = appointmentDays[row].times
            pickerView.reloadComponent(1)
            return appointmentDays[row].day
        case 1:
            selectedDate.time = appointmentTimes[row].time
            return appointmentTimes[row].time
        default:
            return nil
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var selectedDay = 0
        switch component {
        case 0:
            selectedDay = row
            selectedDate.day = appointmentDays[selectedDay].day
        case 1:
            selectedDate.time = appointmentDays[selectedDay].times[row].time
        default: break
        }
    }
}
