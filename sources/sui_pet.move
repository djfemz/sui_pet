/// Module: sui_pet
module sui_pet::sui_pet{
    use std::string::String;
    use std::{debug, string};
    use sui_pet::dto;

    public enum Species has copy, store, drop{
        Empty,
        String(String)
    }

    public enum Level has copy, store, drop{
        Empty,
        String(String)
    }

    public struct Pet has key{
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

    

    #[test]
    public fun test_create_new_species(){
        let sp = string::utf8(b"MAMMAL");
        let species = new_species(sp);
        debug::print(&species);
    }
   

    #[test]
    public fun test_mint_pet(){
        let dog = new_pet(create_pet);
        debug::print(&dog);
    }
}



