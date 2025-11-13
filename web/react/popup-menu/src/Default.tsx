import { useEffect } from 'react'
import { CourierInboxPopupMenu, useCourier } from '@trycourier/courier-react'

export default function App() {

  const courier = useCourier();

  const generateCourierJwtOnYourServer = async () => {  
    
    // You should call an endpoint on your backend that wraps the Courier issue-token endpoint.
    // For server sdk samples, see ../server-side

    // Delay to simulate the time it takes to generate the JWT on your server.
    await new Promise((resolve) => setTimeout(resolve, 1000));

    // For this example, we are using an env value, but this should be what is returned from the issue-token api.
    return import.meta.env.VITE_COURIER_JWT;
  };

  useEffect(() => {
    const signIn = async () => {
      const jwt = await generateCourierJwtOnYourServer();
      courier.shared.signIn({
        userId: import.meta.env.VITE_COURIER_USER_ID,
        jwt,
      });
    };
    signIn();
  }, []);

  return <CourierInboxPopupMenu />;
}

