import json
from flask import Flask, request
import requests
from db import db, Menu, Food, AllergensIngredients
from enum import Enum
from time import sleep
from sqlalchemy import create_engine

app = Flask(__name__)
db_filename = "allergens.db"

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///%s' % db_filename
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ECHO'] = False

#URL to get menus from eatery IDs
UNIT_URL = "http://netnutrition.dining.cornell.edu/NetNutrition/1/Unit/SelectUnitFromUnitsList/"
COURSE_URL = "http://netnutrition.dining.cornell.edu/NetNutrition/1/Menu/SelectCourse"
FOOD_URL = "http://netnutrition.dining.cornell.edu/NetNutrition/1/NutritionDetail/ShowItemNutritionLabel"

#Variables for Cookie names
SESSION_ID = "ASP.NET_SessionId"
COOKIE2 = "CBORD.netnutrition2"

#Storing the actual COOKIES
COOKIES = {
    SESSION_ID: None,
    COOKIE2: None
}

#creating the header to send to the URL (with the cookies)
HEADERS = {
    'content-type': 'application/json',
    'Cookie': "CBORD.netnutrition2=NNexternalID=1; _ga=GA1.2.1570109797.1575339944; _gid=GA1.2.859628249.1575339944; cuwltgttime=\"1575502865\"; ASP.NET_SessionId=lju32qm02synvqhuvdolzonf"
}

#enum of eatery IDs
class UNIT_OID(Enum):
    BEAR_NECESSETIES = 1
    BUS_STOP_BAGELS = 2
    CAFE_JENNIE = 3
    CORNELL_DAIRY = 4;
    GOLDIES = 5
    THE_IVY_ROOM = 6
    MATTINS = 7
    SWEET_SENSATIONS = 8
    TRILLIUM = 9
    MARTHAS_EXPRESS = 10
    TAKE_US_HOME = 11

db.init_app(app)
with app.app_context():
    db.create_all()

#routes
@app.route("/api/menus/test/") #test route to see how to grab cookies from a URL
def getCookies():
    return json.dumps({"data": [COOKIES, HEADERS]}), 200

#returns all menus currently in the database
@app.route("/api/menus/all/")
def getMenus():
    menus = Menu.query.all()
    res = {"success": True, "data": [m.serialize() for m in menus]}
    return json.dumps(res), 200

@app.route("/api/menus/<int:oid>/")
def getFoods(oid):
    foods = Food.query.filter_by(oid = oid)
    res = {"success": True, "data": [food.serialize() for food in foods]}
    return json.dumps(res), 200

@app.route("/api/food/<int:detailOid>/")
def getAllergens(detailOid):
    allergens = AllergensIngredients.query.filter_by(detailOid = detailOid)
    res = {"success": True, "data": [allergen.serialize() for allergen in allergens]}
    return json.dumps(res), 200

@app.route("/api/menus/filter/")
def getFoodWithoutAllergen():
    post_body = json.loads(request.data)
    allergens = post_body.get('allergens', '').split(';')
    foods = AllergensIngredients.query.all()
    available = []
    for food in foods:
        toAdd = True
        foodIng = food.ingredients.lower()
        foodAll = food.allergens.lower()
        foodName = food.foodName.lower()
        for allergen in allergens:
            allergen = allergen.lower()
            if allergen in foodIng or allergen in foodAll or allergen in foodName:
                toAdd = False
        if toAdd:
            available.append(food.serialize())
    return json.dumps({"success": True, "data": available})

@app.route("/api/menus/<int:unitOid>/filter/")
def getFoodWithoutAllergenByLocation(unitOid):
    post_body = json.loads(request.data)
    allergens = post_body.get('allergens', '').split(';')
    menus = Menu.query.filter_by(unitOid = unitOid)
    menusOIDs = []
    for menu in menus:
        menusOIDs.append(menu.oid)
    foods = []
    for menuOID in menusOIDs:
        foodsByOid = Food.query.filter_by(oid = menuOID)
        for food in foodsByOid:
            detailOid = food.detailOid
            infoods = False
            for element in foods:
                if element.detailOid == detailOid:
                    infoods = True
            if not infoods:
                foods.append(AllergensIngredients.query.filter_by(detailOid = detailOid).first())

    available = []
    for food in foods:
        toAdd = True
        foodIng = food.ingredients.lower()
        foodAll = food.allergens.lower()
        foodName = food.foodName.lower()
        for allergen in allergens:
            allergen = allergen.lower()
            if allergen in foodIng or allergen in foodAll or allergen in foodName:
                toAdd = False
        if toAdd:
            available.append(food.serialize())
    return json.dumps({"success": True, "data": available})

@app.route("/api/menus/filterMenu/<int:oid>/")
def getFoodWithoutAllergenByMenu(oid):
    post_body = json.loads(request.data)
    allergens = post_body.get('allergens', '').split(';')

    foods = []
    foodsByOid = Food.query.filter_by(oid = oid)
    for food in foodsByOid:
        detailOid = food.detailOid
        infoods = False
        for element in foods:
            if element.detailOid == detailOid:
                infoods = True
        if not infoods:
            foods.append(AllergensIngredients.query.filter_by(detailOid = detailOid).first())

    available = []
    for food in foods:
        toAdd = True
        foodIng = food.ingredients.lower()
        foodAll = food.allergens.lower()
        foodName = food.foodName.lower()
        for allergen in allergens:
            allergen = allergen.lower()
            if allergen in foodIng or allergen in foodAll or allergen in foodName:
                toAdd = False
        if toAdd:
            available.append(food.serialize())
    return json.dumps({"success": True, "data": available})

#updates the cookie stored in the database
@app.route("/api/menus/updatecookies/", methods = ["POST"])
def updateCookies():
    global COOKIES
    global HEADERS
    session = requests.Session()
    getcook = session.get("http://netnutrition.dining.cornell.edu/NetNutrition").cookies
    COOKIES = session.cookies.get_dict()
    print(COOKIES)

    headerCookie = SESSION_ID + "=" + COOKIES[SESSION_ID] + "; " + COOKIE2 + "=" + COOKIES[COOKIE2]

    headerCookie = "CBORD.netnutrition2=NNexternalID=1; _ga=GA1.2.1570109797.1575339944; _gid=GA1.2.859628249.1575339944; cuwltgttime=\"1575502865\"; ASP.NET_SessionId=lju32qm02synvqhuvdolzonf"
    HEADERS['Cookie'] = headerCookie

    return json.dumps(COOKIES), 200

#adds all menus for a specific eatery to the database
@app.route("/api/menus/initializeMenu/<int:id>/", methods = ['POST'])
def initMenus(id):
    #if the eatery is not in the database, return an error
    try:
        eateryName = UNIT_OID(id)
    except ValueError:
        return json.dumps({"success": False, "error": "invalid eatery"})

    eateryName = str(eateryName.name)
    print("MENUS OF", eateryName)

    #currently updating cookies for every call; this is inefficient
    #will figure out how to update once a day by actual deployment
    #updateCookies()
    if(id < 10):
        res = requests.post(UNIT_URL, data=json.dumps({"unitOid": id}),headers=HEADERS)
        res2 = res.json()
        res2 = res2['panels']
        for r in res2:
            if r['id'] == "coursesPanel":
                res2 = r['html']

        sections = res2.split('<')
        onclicks = []
        for line in range(len(sections)):
            if "onclick" in sections[line] and "selectCourse" in sections[line]:
                onclicks.append(sections[line])

        for menuOptions in onclicks:
            openIndex = menuOptions.find("javascript:NetNutrition.UI.selectCourse(")
            openIndex = openIndex + len("javascript:NetNutrition.UI.selectCourse(")
            closeIndex = menuOptions.find(")")
            menuOid = menuOptions[openIndex:closeIndex]
            if not menuOid.isdigit():
                return json.dumps({"success": False, "error": "oh boy something went wrong"}), 400

            menuOid = int(menuOid)

            endIndex = menuOptions.find(">") + 1
            menuName = menuOptions[endIndex:]
    else:
        print("in else")
        menuOid = id
        menuName = eateryName
    menu = Menu(
        unitOid = id,
        oid = menuOid,
        eateryName = eateryName,
        menuName = menuName
    )
    print(menuOid)
    existCheck = Menu.query.filter_by(unitOid = id, oid = menuOid, eateryName = eateryName, menuName = menuName).first()
    if not existCheck:
        db.session.add(menu)
    db.session.commit()

    return json.dumps({"success": True, "data": [m.serialize() for m in Menu.query.filter_by(unitOid = id)]}), 200


@app.route("/api/menus/initializeFood/<int:oid>/", methods = ["POST"])
def initFood(oid):
    #updateCookies()
    menus = Menu.query.filter_by(oid = oid).first()
    print("FOOD OF", menus.menuName)
    session = requests.Session()
    res = session.post(COURSE_URL, data=json.dumps({"oid": oid}),headers=HEADERS)
    if(oid == 10 or oid == 11):
        res = session.post(UNIT_URL, data=json.dumps({"unitOid": oid}),headers=HEADERS)
    res = res.json()['panels'];
    for r in res:
        if len(r['html']) > 5:
            res = r['html']
            break;
    sections = res.split("<")
    onclicks = []
    for line in range(len(sections)):
        if "onclick" in sections[line] and "getItemNutritionLabel" in sections[line]:
            onclicks.append(sections[line])

    for foodOptions in onclicks:
        openIndex = foodOptions.find("javascript:NetNutrition.UI.getItemNutritionLabel(")
        openIndex = openIndex + len("javascript:NetNutrition.UI.getItemNutritionLabel(")
        closeIndex = openIndex + foodOptions[openIndex:].find(")")
        detailOid = foodOptions[openIndex:closeIndex]
        if not detailOid.isdigit():
            print("openIndex", openIndex)
            print("closeIndex", closeIndex)
            return json.dumps({"success": False, "Error": "Oh boy something went wrong"}), 400

        detailOid = int(detailOid)
        nameIndex = foodOptions.find(">") + 1
        foodName = foodOptions[nameIndex:]
        #print(detailOid)
        menuName = Menu.query.filter_by(oid=oid).first().menuName

        food = Food(
            oid = oid,
            detailOid = detailOid,
            menuName = menuName,
            foodName = foodName
        )

        print(food.foodName)

        existCheck = Food.query.filter_by(detailOid = detailOid).first()
        if not existCheck:
            #print(foodName)
            db.session.add(food)
    db.session.commit()
    foodArr = [f.serialize() for f in Food.query.filter_by(oid = oid)]
    return json.dumps({"success": True, "data": foodArr}), 200

@app.route("/api/menus/initializeIng/<int:detailOid>/", methods = ["POST"])
def initIng(detailOid):
    #updateCookies()
    existCheck1 = AllergensIngredients.query.filter_by(detailOid = detailOid).first()
    #if not not existCheck1 and len(existCheck1.ingredients) > 0:
    #    return json.dumps({"success": False, "error": "already in db"}), 400
    #if not not existCheck1:
    #    db.session.delete(existCheck1)
    #    db.session.commit()
    #food = Food.query.filter_by(detailOid = detailOid).first()

    res = requests.post("http://netnutrition.dining.cornell.edu/NetNutrition/1/NutritionDetail/ShowItemNutritionLabel", data = json.dumps({"detailOid": detailOid}), headers = HEADERS)
    resText = res.text
    sections = resText.split("<")
    ingredients = ""
    allergensArr = []
    allergens = ""
    for line in sections:
        if "cbo_nn_LabelIngredients" in line:
            openIndex = line.find(">") + len(">")
            ingredients = line[openIndex:]
        elif "cbo_nn_LabelAllergens" in line:
            openIndex = line.find(">") + len(">")
            allergens = line[openIndex:].split(",")
    for allergen in range(len(allergensArr)):
        if(allergensArr[allergen].startswith("&nbsp;")):
            allergensArr[allergen] = allergensArr[allergen][len("&nbsp;"):]
        elif(allergensArr[allergen]).startswith("&amp;nbsp;"):
            allergensArr[allergen] = allergensArr[allergen][len("&amp;nbsp;"):]
        allergens = allergens + "," + allergensArr[allergen]

    print("INGREDIENTS:",ingredients)
    print("ALLERGENS:", allergens)

    foodName = food.foodName
    alcohol = "Alcohol" in allergensArr
    eggs = "Eggs" in allergensArr
    fish = "Fish" in allergensArr
    gluten = "Gluten" in allergensArr
    milk = "Milk" in allergensArr
    peanuts = "Peanuts" in allergensArr
    pork_U = "Pork (U)" in allergensArr
    sesame = "Sesame" in allergensArr
    soy = "Soy" in allergensArr
    treeNuts = "Tree Nuts" in allergensArr
    wheat = "Wheat" in allergensArr

    allergensIngredients = AllergensIngredients(
        detailOid = detailOid,
        foodName = foodName,
        ingredients = ingredients,
        allergens = allergens,
        alcohol = alcohol,
        eggs = eggs,
        fish = fish,
        gluten = gluten,
        milk = milk,
        peanuts = peanuts,
        pork_U = pork_U,
        sesame = sesame,
        soy = soy,
        treeNuts = treeNuts,
        wheat = wheat
    )
    existCheck = AllergensIngredients.query.filter_by(detailOid = detailOid).first()
    if not existCheck:
        db.session.add(allergensIngredients)
    db.session.commit()

    return json.dumps({"data": [ai.serialize() for ai in AllergensIngredients.query.filter_by(detailOid = detailOid)]}), 200

@app.route("/api/menus/initializeIng2/<int:id>/", methods = ["DELETE"])
def deleteIng2(id):
    food = Food.query.filter_by(id=id).first()
    ai = AllergensIngredients.query.filter_by(detailOid = food.detailOid).first()
    db.session.delete(ai)
    db.session.commit()
    return json.dumps({"success": True, "data": ai.serialize()}), 200

@app.route("/api/menus/initializeIng2/<int:id>/", methods = ["POST"])
def initIng2(id):
    #updateCookies()
    food = Food.query.filter_by(id=id).first()
    detailOid = food.detailOid
    existCheck1 = AllergensIngredients.query.filter_by(detailOid = detailOid).first()
    #if not not existCheck1 and len(existCheck1.ingredients) > 0:
    #    return json.dumps({"success": False, "error": "already in db"}), 400
    #if not not existCheck1:
    #    db.session.delete(existCheck1)
    #    db.session.commit()
    #food = Food.query.filter_by(detailOid = detailOid).first()

    res = requests.post("http://netnutrition.dining.cornell.edu/NetNutrition/1/NutritionDetail/ShowItemNutritionLabel", data = json.dumps({"detailOid": detailOid}), headers = HEADERS)
    resText = res.text
    sections = resText.split("<")
    ingredients = ""
    allergensArr = []
    allergens = ""
    for line in sections:
        if "cbo_nn_LabelIngredients" in line:
            openIndex = line.find(">") + len(">")
            ingredients = line[openIndex:]
        elif "cbo_nn_LabelAllergens" in line:
            openIndex = line.find(">") + len(">")
            allergensArr = line[openIndex:].split(",")
    for allergen in range(len(allergensArr)):
        if(allergensArr[allergen].startswith("&nbsp;")):
            allergensArr[allergen] = allergensArr[allergen][len("&nbsp;"):]
        elif(allergensArr[allergen]).startswith("&amp;nbsp;"):
            allergensArr[allergen] = allergensArr[allergen][len("&amp;nbsp;"):]
        allergens = allergens + "," + allergensArr[allergen]

    print("INGREDIENTS:",ingredients)
    print("ALLERGENS:", allergens)

    foodName = food.foodName
    alcohol = "Alcohol" in allergensArr
    eggs = "Eggs" in allergensArr
    fish = "Fish" in allergensArr
    gluten = "Gluten" in allergensArr
    milk = "Milk" in allergensArr
    peanuts = "Peanuts" in allergensArr
    pork_U = "Pork (U)" in allergensArr
    sesame = "Sesame" in allergensArr
    soy = "Soy" in allergensArr
    treeNuts = "Tree Nuts" in allergensArr
    wheat = "Wheat" in allergensArr

    allergensIngredients = AllergensIngredients(
        detailOid = detailOid,
        foodName = foodName,
        ingredients = ingredients,
        allergens = allergens,
        alcohol = alcohol,
        eggs = eggs,
        fish = fish,
        gluten = gluten,
        milk = milk,
        peanuts = peanuts,
        pork_U = pork_U,
        sesame = sesame,
        soy = soy,
        treeNuts = treeNuts,
        wheat = wheat
    )
    existCheck = AllergensIngredients.query.filter_by(detailOid = detailOid).first()
    if not existCheck:
        db.session.add(allergensIngredients)
    db.session.commit()

    return json.dumps({"data": [ai.serialize() for ai in AllergensIngredients.query.filter_by(detailOid = detailOid)]}), 200

@app.route("/api/menus/initAll/", methods = ['POST'])
def initAll():
    for oid in UNIT_OID:
        initMenus(oid.value)


#    menus = Menu.query.all()
#    for menu in menus:
#        print("MENU:",menu.oid)
#         initFood(menu.oid)
#        foods = Food.query.filter_by(oid = menu.oid)
#        for food in foods:
#            print(food.detailOid)
    #        requests.post("localhost:5000/api/menus/initializeIng/" + str(food.detailOid) + "/")
#            initIng(food.detailOid)
    return json.dumps({"success": True}), 200

#deletes a menu given an id from the database
@app.route("/api/menu/<int:id>/", methods = ["DELETE"])
def deleteMenu(id):
    menu = Menu.query.filter_by(id=id).first()
    if not menu:
        return json.dumps({"success": False, "error": "menu not in database"}), 404
    db.session.delete(menu)
    db.session.commit()
    return json.dumps({"success": True, "data": menu.serialize()}), 201

if __name__ == "__main__":
    app.run(host = "0.0.0.0", port = 5000, debug = True)
