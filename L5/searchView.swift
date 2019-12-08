import UIKit

class searchView: UIViewController {
    var nameLabel:UILabel!
    var foodLabel:UILabel!
    var image:UIImageView!
    var searchButton:UIButton!
    var isselected:Bool = false
    
    var savebutton: UIBarButtonItem!
    
    
    var restaurant:Restaurant!
    


   

    // This function is required, you can ignore it
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = " Search for Food"
        
        
        
        // Setting the textfield's placeholder text to be the one we received from the custom initializer
        
        
        
        savebutton = UIBarButtonItem()
        let savebutton = UIBarButtonItem(title: "", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = savebutton
        
        searchButton = UIButton()
               searchButton.backgroundColor = .white
               searchButton.addTarget(self, action: #selector(followButtonPressed), for: .touchUpInside)
               searchButton.setTitle("Search For dishes in Menu", for: .normal)
               searchButton.setTitleColor(.systemBlue, for: .normal)
               searchButton.layer.borderColor = UIColor.systemBlue.cgColor
               searchButton.layer.borderWidth = 1
               searchButton.translatesAutoresizingMaskIntoConstraints = false
               searchButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
              view.addSubview(searchButton)
               
        
       image = UIImageView()
       image.translatesAutoresizingMaskIntoConstraints = false
       image.contentMode = .scaleAspectFill
       image.layer.masksToBounds = true
       image.image = UIImage(named: restaurant.profileImageName)
       view.addSubview(image)
       
             foodLabel = UILabel()
             foodLabel.text = restaurant.food
             foodLabel.textColor = .black
             foodLabel.textAlignment = .center
             foodLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
             foodLabel.translatesAutoresizingMaskIntoConstraints = false
             view.addSubview(foodLabel)
        

        
        
        nameLabel = UILabel()
        nameLabel.text = restaurant.name
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
 setupConstraints()
    }
    
    
    func setupConstraints() {
           // textField constraints
           
             
       
           
           NSLayoutConstraint.activate([
                             nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                             nameLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor,constant:-40),
                            
                             
                         ])
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor,constant:40),
                   image.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 40),
                   
               ])
      
        
        NSLayoutConstraint.activate([
            foodLabel.topAnchor.constraint(equalTo: image.bottomAnchor,constant:50),
            foodLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor,constant:-40),
           
            
        ])
          
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: foodLabel.bottomAnchor,constant:50),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//            searchButton.leadingAnchor.constraint(equalTo: view.centerXAnchor,constant:-90),
           
            
        ])
          
        
       }
    
    @objc func followButtonPressed() {
    
          searchButton.setTitleColor(isselected ? .systemBlue : .white, for: .normal)
          searchButton.backgroundColor = isselected ? .white : .systemBlue
        isselected.toggle()
        var  vc = SearchViewController()
        vc.restaurant = restaurant
            
            navigationController?.pushViewController(vc, animated: true)
            
            
          
      }
    
    
    
}

