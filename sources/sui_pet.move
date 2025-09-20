/// Module: sui_pet
module sui_pet::sui_pet{
    use std::string::String;
    use std::{debug, string};
    use sui_pet::dto;
    #[test_only]
    use sui::test_scenario;
    public enum Species has copy, store, drop{
        Empty,
        String(String)
    }

    public enum Level has copy, store, drop{
        Empty,
        String(String)
    }

    public struct Pet has key, store{
        id:UID,
        name:String,
        species: Species,
        level: Level,
        is_hungry:bool
    }

    public struct FoodItem has key, store{
        id:UID,
        name:String,
        nutrition:u8
    }

    public fun new_species(species:String) : Species{
        let allowed_species = vector<String>[
            string::utf8(b"MAMMAL"), string::utf8(b"AVES"),
            string::utf8(b"PISCES")
            ];
        let mut index = 0;
        while(index < allowed_species.length()){
            if(allowed_species[index] == species){
               return Species::String(species);
            };
            index = index + 1;
        };
        Species::Empty
    }

     public fun new_level(level:String) : Level{
        Level::String(level)
    }

    public fun feed(pet : & mut Pet, food:FoodItem, ctx:&mut TxContext) {
        if(!pet.is_hungry){
            debug::print(&string::utf8(b"The pet is not hungry."));
            transfer::public_transfer(food, ctx.sender());
            return;
        };
        pet.is_hungry = false;
        debug::print(&string::utf8(b"The pet has been fed."));
        transfer::public_transfer(food, ctx.sender());
    }
    
    public fun buy_food(name:String, ctx:&mut TxContext){
        let food = FoodItem{
            id:object::new(ctx),
            name:name,
            nutrition:10
        };
        transfer::public_transfer(food, ctx.sender());

    }

    #[allow(lint(self_transfer))]
    public fun new_pet(create_pet_req:dto::CreatePetRequest, ctx:&mut TxContext):Pet {
        let id = object::new(ctx);
        let species = new_species(string::utf8(b"MAMMAL"));
        let level = new_level(string::utf8(b"LEVEL_1"));
        let pet = Pet{
            id:id,
            name:create_pet_req.get_name(),
            species:species,
            level:level,
            is_hungry:true
        };
        debug::print(&pet);
        transfer::public_transfer(create_pet_req,  ctx.sender());
        pet
    }

    public fun create_pet(create_pet_req:dto::CreatePetRequest, ctx:&mut TxContext){
        let pet = new_pet(create_pet_req, ctx);
        transfer::public_transfer(pet, ctx.sender());
    }
    

    #[test]
    public fun test_create_new_species(){
        let sp = string::utf8(b"AVES");
        let species = new_species(sp);
        debug::print(&species);
    }
   

    #[test]
    public fun test_mint_pet(){
        let sender_address = @0x3;
        let mut scenario = test_scenario::begin(sender_address);
        let ctx = scenario.ctx();
        let req = dto::new_pet_request(string::utf8(b"Tommy"), ctx);
        let pet = new_pet(req, ctx);
        transfer::public_transfer(pet, sender_address);
        test_scenario::end(scenario);
    }

    #[test]
    public fun test_feed_pet(){
        let sender_address = @0x42;
        let mut scenario = test_scenario::begin(sender_address);
        let ctx = scenario.ctx();
        let mut pet =  Pet{
            id:object::new(ctx),
            name:string::utf8(b"Tommy"),
            species:Species::String(string::utf8(b"MAMMAL")),
            level:Level::String(string::utf8(b"LEVEL_1")),
            is_hungry:true
        };
        let food = FoodItem{
            id:object::new(ctx),
            name:string::utf8(b"Dog Food"),
            nutrition:10
        };
        pet.feed(food, ctx);
        assert!(!pet.is_hungry, 0);
        transfer::public_transfer(pet, ctx.sender());
        test_scenario::end(scenario);
    }
}



