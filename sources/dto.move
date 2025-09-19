module sui_pet::dto{
    use std::string::String;
    
   
    public struct CreatePetRequest has key, store{
        id: UID,
        name:String,
    }

    public fun create_pet_request( name:String, ctx: &mut TxContext){
        let req = CreatePetRequest{
            id:object::new(ctx),
            name:name
        };
        transfer::public_transfer(req, ctx.sender());
    }

    public fun get_name(req:&CreatePetRequest) : String{
        req.name
    }

}