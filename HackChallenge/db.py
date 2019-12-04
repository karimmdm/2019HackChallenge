from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Menu(db.Model):
    __tablename__ = "menu"
    id = db.Column("id", db.Integer,primary_key = True)
    unitOid = db.Column("unitOid", db.Integer, nullable = False)
    oid = db.Column("oid", db.Integer, nullable = False)
    eateryName = db.Column("eateryName", db.String, nullable = False)
    menuName = db.Column("menuName", db.String, nullable = False)

    def __init__(self, **kwargs):
        self.unitOid = kwargs['unitOid']
        self.oid = kwargs['oid']
        self.eateryName = kwargs['eateryName']
        self.menuName = kwargs['menuName']

    def serialize(self):
        return {
            "id": self.id,
            "unitOid": self.unitOid,
            "oid": self.oid,
            "eateryName": self.eateryName,
            "menuName": self.menuName
        }

class Food(db.Model):
    __tablename__ = "food"
    id = db.Column("id", db.Integer, primary_key = True)
    oid = db.Column("oid", db.Integer, nullable = False)
    detailOid = db.Column("detailOid", db.Integer, nullable = False)
    menuName = db.Column("menuName", db.String, nullable = False)
    foodName = db.Column("foodName", db.String, nullable = False)

    def __init__(self, **kwargs):
        self.oid = kwargs['oid']
        self.detailOid = kwargs['detailOid']
        self.menuName = kwargs['menuName']
        self.foodName = kwargs['foodName']

    def serialize(self):
        return {
            "id": self.id,
            "oid": self.oid,
            "detailOid": self.detailOid,
            "menuName": self.menuName,
            "foodName": self.foodName
        }

class AllergensIngredients(db.Model):
    __tablename__ = "allergens_ingredients"
    id = db.Column("id", db.Integer, primary_key = True)
    detailOid = db.Column("detailOid", db.Integer, nullable = False)
    foodName = db.Column("foodName", db.String, nullable = False)
    ingredients = db.Column("ingredients", db.String, nullable = False)
    allergens = db.Column("allergens", db.String, nullable = False)

    alcohol = db.Column("alcohol", db.Boolean, nullable = False)
    eggs = db.Column("eggs", db.Boolean, nullable = False)
    fish = db.Column("fish", db.Boolean, nullable = False)
    gluten = db.Column("gluten", db.Boolean, nullable = False)
    milk = db.Column("milk", db.Boolean, nullable = False)
    peanuts = db.Column("peanuts", db.Boolean, nullable = False)
    pork_U = db.Column("pork(U)", db.Boolean, nullable = False)
    sesame = db.Column("sesame", db.Boolean, nullable = False)
    soy = db.Column("soy", db.Boolean, nullable = False)
    treeNuts = db.Column("treeNuts", db.Boolean, nullable = False)
    wheat = db.Column("wheat", db.Boolean, nullable = False)

    def __init__(self, **kwargs):
        self.detailOid = kwargs['detailOid']
        self.foodName = kwargs['foodName']
        self.ingredients = kwargs['ingredients']
        self.allergens = kwargs['allergens']
        self.alcohol = kwargs.get('alcohol', False)
        self.eggs = kwargs.get('eggs', False)
        self.fish = kwargs.get('fish', False)
        self.gluten = kwargs.get('gluten', False)
        self.milk = kwargs.get('milk', False)
        self.peanuts = kwargs.get('peanuts', False)
        self.pork_U = kwargs.get('pork_U', False)
        self.sesame = kwargs.get('sesame', False)
        self.soy = kwargs.get('soy', False)
        self.treeNuts = kwargs.get('treeNuts', False)
        self.wheat = kwargs.get('wheat', False)

    def serialize(self):
        return{
            "id": self.id,
            "detailOid": self.detailOid,
            "foodName": self.foodName,
            "ingredients": self.ingredients,
            "alochol": self.alcohol,
            "eggs": self.eggs,
            "fish": self.fish,
            "gluten": self.gluten,
            "milk": self.milk,
            "peanuts": self.peanuts,
            "pork_U" : self.pork_U,
            "sesame" : self.sesame,
            "soy" : self.soy,
            "treeNuts" : self.treeNuts,
            "wheat" : self.wheat
        }
