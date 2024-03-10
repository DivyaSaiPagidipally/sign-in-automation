export default function Inputform(props) {
    return (
      <>
      <label>{props.label}:</label>
      <input type={props.type} placeholder= {`Enter ${props.placeholder}`} ></input><br></br>
      </>
    );
  }