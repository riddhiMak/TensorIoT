//
//  ProfileViewController.swift
//  TensorIoT
//
//  Created by Riddhi Makwana on 04/10/23.
//

import UIKit
import CoreLocation

class ProfileViewController: UIViewController {

    @IBOutlet weak var lblBio : UILabel!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var currentView: TopView!
    @IBOutlet weak var forcastView: BottomView!
   
    var city = "Kolkata"
    var weatherResult: weather?
    var locationManger: CLLocationManager!
    var currentlocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        clearAll()
        getWeather()
        configureComponent()
    }
    
    func configureComponent(){
        collectionView.register(UINib(nibName:"ForcastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"ForcastCollectionViewCell")

        txtSearch.setLeftPaddingPoints(8.0)
        txtSearch.layer.borderColor = UIColor.white.cgColor
        txtSearch.layer.borderWidth = 1.0
        txtSearch.layer.cornerRadius = 4.0
        txtSearch.layer.masksToBounds = true
        txtSearch.attributedPlaceholder = NSAttributedString(
            string: str.searchCity,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        
        APIService.shared.setLatitude("22.5726")
        APIService.shared.setLongitude("88.3639")

    }
    
   
    @IBAction func btnSearchClicked(_ sender : UIButton){
        txtSearch.resignFirstResponder()
        if txtSearch.text != ""{
            self.city = txtSearch.text!
            self.fetchWeatherByCityName(searchedCityName: txtSearch.text!)
        }
    }
    
    @IBAction func todayWeeklyValueChanged(_ sender: UISegmentedControl) {
        clearAll()
        updateViews()
    }

}

extension ProfileViewController {
    func clearAll() {
        currentView.clear()
    }
    
    func updateViews() {
        updateTopView()
        collectionView.reloadData()
    }
    
    func updateTopView() {
        guard let weatherResult = weatherResult else {
            return
        }
        currentView.updateView(currentWeather: weatherResult.current, city: city)
    }
    
    func getCityName(of location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                self.city = placemark.locality ?? ""
            }
        }
    }
}

extension ProfileViewController {
    func getWeather() {
        self.showIndicator(withTitle: str.Logging, and: "")
        APIService.shared.getWeather(onSuccess: { (result) in
            self.hideIndicator()
            self.weatherResult = result
            self.getCityName(of: CLLocation(latitude: self.weatherResult?.lat ?? 0.0, longitude: self.weatherResult?.lon ?? 0.0))
            self.weatherResult?.sortDailyArray()
            self.weatherResult?.sortHourlyArray()
            self.fetchData()
            self.updateViews()
            
        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
    }
    
    func fetchData(){

        guard let email = UserDefaults.standard.value(forKey: NSUDKey.Email) as? String else {
            return
        }
        
        guard let data = UserDefaults.standard.data(forKey: NSUDKey.profileImage) else { return }
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        let image = UIImage(data: decoded)
        imgProfile.image = image
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
        imgProfile.layer.masksToBounds = true
        let safeEmail = DatabaseManager.toSafeEmail(with: email)
        
        // Fetch
        DatabaseManager.shared.fetchDataFromDatabase(tName: FirebaseCollections.FUsers, child: safeEmail) { result in
            switch result{
            case .success(let date):
                guard let userData = date as? [String: Any],
                      let bio = userData["bio"] as? String,
                      let name = userData["username"] as? String else{
                    return
                }
                self.lblBio.text = bio
                self.lblName.text = name
            case .failure(let error):
                print("Failed to Get Data with error: \(error)")
            }
        }
    }
    
    func fetchWeatherByCityName(searchedCityName : String) {
        if searchedCityName != "" {
            CLGeocoder().geocodeAddressString(searchedCityName) { (placemarks, error) in
                if let location = placemarks?.first?.location {
                    APIService.shared.setLatitude(location.coordinate.latitude)
                    APIService.shared.setLongitude(location.coordinate.longitude)
                    self.getWeather()
                }
            }
        }
    }
   
}
extension ProfileViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let title = forcastView.getSelectedTitle()
        
        if title == "Today" {
            return weatherResult?.hourly.count ?? 0
        } else if title == "Weekly" {
            return weatherResult?.daily.count ?? 0
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let title = forcastView.getSelectedTitle()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForcastCollectionViewCell", for: indexPath as IndexPath) as! ForcastCollectionViewCell

        if title == "Today" {
            if let data = weatherResult{
                let hour = data.hourly[indexPath.row]
                let date = Date(timeIntervalSince1970: Double(hour.dt))
                let hourString = Date.getHourFrom(date: date)
                let weatherIconName = hour.weather[0].icon
                let weatherTemperature = hour.temp
                
                cell.topLabel.text = hourString
                cell.imgForcast.image = UIImage(named: weatherIconName)
                cell.bottomLabel.text = "\(Int(weatherTemperature.rounded()))°F"
            }

        } else if title == "Weekly" {
            if let data = weatherResult{
                let day = data.daily[indexPath.row]
                let dayString = day.dt.dayDateMonth
                let weatherIconName = day.weather[0].icon
                let weatherTemperature = day.temp.day
                
                cell.topLabel.text = dayString
                cell.imgForcast.image = UIImage(named: weatherIconName)
                cell.bottomLabel.text = "\(Int(weatherTemperature.rounded()))°F"
            }
        }
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = forcastView.getSelectedTitle()
        if title == "Weekly" {
            let detailVC = UIStoryboard.profile.instantiateViewController(withIdentifier: "WeatherDetailViewController") as! WeatherDetailViewController
            if let data = weatherResult{
                let day = data.daily[indexPath.row]
                detailVC.daily = day
            }
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
}
