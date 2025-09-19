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

    public fun new_species(species:String) : Species{
        let sp = string::into_bytes(species);
        let mammal = string::into_bytes(string::utf8(b"MAMMAL"));

        if(sp==mammal){
             Species::String(species)
        }else{
            abort 1
        }
        
    }

     public fun new_level(level:String) : Level{
        Level::String(level)
    }

    
    #[allow(lint(self_transfer))]
    public fun new_pet(create_pet_req:dto::CreatePetRequest, ctx:&mut TxContext) {
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
        transfer::public_transfer(pet, ctx.sender());
    }
    

    #[test]
    public fun test_create_new_species(){
        let sp = string::utf8(b"MAMMAL");
        let species = new_species(sp);
        debug::print(&species);
    }
   

    // #[test]
    // public fun test_mint_pet(){
    //     let sender_address = @0x3;
    //     let mut scenario = test_scenario::begin(sender_address);
    //     let ctx = scenario.ctx();
    //     let create_pet_req = dto::create_pet_request(ctx, string::utf8(b"Tommy"));
    //     new_pet(ctx, create_pet_req);
    //     test_scenario::end(scenario);
    // }
}



