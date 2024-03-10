import { Heading } from "./components/Heading";
import { Body } from "./components/Body";
import { Footer } from "./components/Footer";
import "./css/App.css";

function App() {
  return (
    <>
        <div className="overall">
              <Heading />
              <div className="div">
                <Body />
                <Footer name="Cancel" />
                <Footer name="Create" />
              </div>
            </div>
    </>
  );
}

export default App;