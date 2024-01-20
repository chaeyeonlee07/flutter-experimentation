import { createBrowserRouter } from 'react-router-dom';

const router = createBrowserRouter([{
  path: "/", element: <Layout />, children: [{ path: "", element: <Home /> }, { path: "profile", element: <Profile /> }]
}])


function App() {

  return <></>;
}

export default App
