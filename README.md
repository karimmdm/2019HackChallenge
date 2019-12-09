# Safe Eat
## - Eat safe when we take care of finding the allergens for you -
### Screens: 
<img width="451" alt="Screen Shot 2019-12-08 at 23 04 48 copy" src="https://user-images.githubusercontent.com/42630113/70406672-8ebffd80-1a0f-11ea-9639-570dbbfd1acb.png">

<img width="450" alt="Screen Shot 2019-12-08 at 23 04 48" src="https://user-images.githubusercontent.com/42630113/70406686-92538480-1a0f-11ea-8019-83025a82690e.png">


### Description: 
Ever went to an eatery looking for gluten-free food and returned disappointed? Not any more. Safe Eat is an app that displays a list of eating options according to the user’s dietary restrictions or allergen information for on-campus eateries. Students with allergies can filter through food at different eateries by putting in their allergen information in a search bar. They can also filter through different eateries based on on-campus locations. Want to know more about what dishes your favourite eateries are serving but have a lot of allergies? Enjoy SafeEat!


### iOS Implementation: 
- Used NSLAyout Constraints. 
- Used Two UICollectionViews and a UITableView 
- Two UINavigationControllers to navigate between three screens
- Implemented a detailed view that displays the picture of the eatery and which category it belongs to.
- Used a searchViewController and integrated with an API to navigate to a particular eatery and display the food served by it that does not contain the allergens listed in the search bar.
                    
### Backend Implementation: 
- Used SQLAlchemy and Flask to create and update the Database
- Implemented different routes to access food and ingredients in the database
- Deployed using Google cloud to http://35.199.7.241/
### Creators: 
Maitreyi Chatterjee, Masbubul Karim, Raahi Menon, Yaoyao Ma
