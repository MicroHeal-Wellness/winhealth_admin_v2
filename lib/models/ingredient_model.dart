
import 'dart:convert';

IngredientModel ingredientModelFromJson(String str) => IngredientModel.fromJson(json.decode(str));

String ingredientModelToJson(IngredientModel data) => json.encode(data.toJson());

class IngredientModel {
    String? id;
    String? userCreated;
    DateTime? dateCreated;
    dynamic userUpdated;
    dynamic dateUpdated;
    String? type;
    String? description;
    String? category;
    String? moisture;
    String? protein;
    String? totalFat;
    String? totalDietaryFiber;
    String? insolubleDf;
    String? solubleDf;
    String? carbohydrates;
    String? energyKiloJoules;
    String? energyKcal;
    String? thiamineB1;
    String? riboflavinB2;
    String? niacinB3;
    String? pantotenicAcidB5;
    String? totalB6;
    String? biotinB7;
    String? totalFolatesB9;
    dynamic totalAscorbicAcidVitC;
    String? vitA;
    String? vitE;
    String? vitK2;
    String? aluminiumAl;
    dynamic arsenicAs;
    String? cadmiumCd;
    String? calciumCa;
    String? chromiumCr;
    String? cobaltCo;
    String? copperCu;
    String? ironFe;
    String? leadPb;
    String? lithiumLi;
    String? magnesiumMg;
    String? manganeseMn;
    dynamic mercuryHg;
    String? molybdeumMo;
    String? nickelNi;
    String? phosphorousP;
    String? potassiumK;
    dynamic seleniumSe;
    String? sodiumNa;
    String? zincZn;

    IngredientModel({
        this.id,
        this.userCreated,
        this.dateCreated,
        this.userUpdated,
        this.dateUpdated,
        this.type,
        this.description,
        this.category,
        this.moisture,
        this.protein,
        this.totalFat,
        this.totalDietaryFiber,
        this.insolubleDf,
        this.solubleDf,
        this.carbohydrates,
        this.energyKiloJoules,
        this.energyKcal,
        this.thiamineB1,
        this.riboflavinB2,
        this.niacinB3,
        this.pantotenicAcidB5,
        this.totalB6,
        this.biotinB7,
        this.totalFolatesB9,
        this.totalAscorbicAcidVitC,
        this.vitA,
        this.vitE,
        this.vitK2,
        this.aluminiumAl,
        this.arsenicAs,
        this.cadmiumCd,
        this.calciumCa,
        this.chromiumCr,
        this.cobaltCo,
        this.copperCu,
        this.ironFe,
        this.leadPb,
        this.lithiumLi,
        this.magnesiumMg,
        this.manganeseMn,
        this.mercuryHg,
        this.molybdeumMo,
        this.nickelNi,
        this.phosphorousP,
        this.potassiumK,
        this.seleniumSe,
        this.sodiumNa,
        this.zincZn,
    });

    factory IngredientModel.fromJson(Map<String, dynamic> json) => IngredientModel(
        id: json["id"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"],
        type: json["type"],
        description: json["description"],
        category: json["category"],
        moisture: json["moisture"],
        protein: json["protein"],
        totalFat: json["total_fat"],
        totalDietaryFiber: json["total_dietary_fiber"],
        insolubleDf: json["insoluble_df"],
        solubleDf: json["soluble_df"],
        carbohydrates: json["carbohydrates"],
        energyKiloJoules: json["energy_kilo_joules"],
        energyKcal: json["energy_kcal"],
        thiamineB1: json["thiamine_b1"],
        riboflavinB2: json["riboflavin_b2"],
        niacinB3: json["niacin_b3"],
        pantotenicAcidB5: json["pantotenic_acid_b5"],
        totalB6: json["total_b6"],
        biotinB7: json["biotin_b7"],
        totalFolatesB9: json["total_folates_b9"],
        totalAscorbicAcidVitC: json["total_ascorbic_acid_vit_c"],
        vitA: json["vit_a"],
        vitE: json["vit_e"],
        vitK2: json["vit_k2"],
        aluminiumAl: json["aluminium_al"],
        arsenicAs: json["arsenic_as"],
        cadmiumCd: json["cadmium_cd"],
        calciumCa: json["calcium_ca"],
        chromiumCr: json["chromium_cr"],
        cobaltCo: json["cobalt_co"],
        copperCu: json["copper_cu"],
        ironFe: json["iron_fe"],
        leadPb: json["lead_pb"],
        lithiumLi: json["lithium_li"],
        magnesiumMg: json["magnesium_mg"],
        manganeseMn: json["manganese_mn"],
        mercuryHg: json["mercury_hg"],
        molybdeumMo: json["molybdeum_mo"],
        nickelNi: json["nickel_ni"],
        phosphorousP: json["phosphorous_p"],
        potassiumK: json["potassium_k"],
        seleniumSe: json["selenium_se"],
        sodiumNa: json["sodium_na"],
        zincZn: json["zinc_zn"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated,
        "type": type,
        "description": description,
        "category": category,
        "moisture": moisture,
        "protein": protein,
        "total_fat": totalFat,
        "total_dietary_fiber": totalDietaryFiber,
        "insoluble_df": insolubleDf,
        "soluble_df": solubleDf,
        "carbohydrates": carbohydrates,
        "energy_kilo_joules": energyKiloJoules,
        "energy_kcal": energyKcal,
        "thiamine_b1": thiamineB1,
        "riboflavin_b2": riboflavinB2,
        "niacin_b3": niacinB3,
        "pantotenic_acid_b5": pantotenicAcidB5,
        "total_b6": totalB6,
        "biotin_b7": biotinB7,
        "total_folates_b9": totalFolatesB9,
        "total_ascorbic_acid_vit_c": totalAscorbicAcidVitC,
        "vit_a": vitA,
        "vit_e": vitE,
        "vit_k2": vitK2,
        "aluminium_al": aluminiumAl,
        "arsenic_as": arsenicAs,
        "cadmium_cd": cadmiumCd,
        "calcium_ca": calciumCa,
        "chromium_cr": chromiumCr,
        "cobalt_co": cobaltCo,
        "copper_cu": copperCu,
        "iron_fe": ironFe,
        "lead_pb": leadPb,
        "lithium_li": lithiumLi,
        "magnesium_mg": magnesiumMg,
        "manganese_mn": manganeseMn,
        "mercury_hg": mercuryHg,
        "molybdeum_mo": molybdeumMo,
        "nickel_ni": nickelNi,
        "phosphorous_p": phosphorousP,
        "potassium_k": potassiumK,
        "selenium_se": seleniumSe,
        "sodium_na": sodiumNa,
        "zinc_zn": zincZn,
    };
}
