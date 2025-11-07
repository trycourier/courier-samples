import { useEffect } from 'react'
import { CourierToast, useCourier } from '@trycourier/courier-react'

export default function App() {

  const courier = useCourier();

  // To obtain a working JWT for authentication, you need to call Courier's issue-token endpoint.
  // You must pass your user ID as part of the request to receive a JWT token specific to that user.
  // Example: POST to https://api.courier.com/authorize/issue-token with `{ "user_id": "<your_user_id>" }` in the payload.
  // For more information and detailed docs, see: https://www.courier.com/docs/reference/authorization
  const getJWTFromBackend = async () => {  
    // const response = await fetch('https://api.courier.com/issue-token', {
    //   method: 'POST',
    //   headers: {
    //     'Authorization': `Bearer ${process.env.COURIER_API_KEY}`,
    //     'Content-Type': 'application/json'
    //   },
    //   body: JSON.stringify({
    //     scope: `user_id:${your_user_id} inbox:read:messages inbox:write:events read:preferences write:preferences read:brands`,
    //     expires_in: '1d'
    //   })
    // });
    return import.meta.env.VITE_COURIER_JWT;
  };

  useEffect(() => {
    const fetchJWTAndSignIn = async () => {
      const jwt = await getJWTFromBackend();      
      courier.shared.signIn({
        userId: import.meta.env.VITE_COURIER_USER_ID,
        jwt: jwt,
      });
    };

    fetchJWTAndSignIn();
  }, []);

  return (
    <CourierToast/>
  );
}

