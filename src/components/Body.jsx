import Inputform from "./Inputform";
export function Body()
{
    return(
    <>
    < Inputform label="First name" type="text" placeholder="Firstname" />
    < Inputform label="Last name" type="text" placeholder="Lastname" /> 
    < Inputform label="Email" type="email" placeholder="Email Id"  />
    < Inputform label="Phonenumber" type="tel" placeholder="+91" />
    </>
    );
}