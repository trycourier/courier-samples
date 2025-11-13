import { useEffect } from 'react'
import { CourierToast, useCourier } from '@trycourier/courier-react'

export default function App() {

  const courier = useCourier();

  const generateCourierJwtOnYourServer = async () => {  
    
    // You should call an endpoint on your backend that wraps the Courier issue-token endpoint.
    // For server sdk samples, see ../server-side

    // Delay to simulate the time it takes to generate the JWT on your server.
    await new Promise((resolve) => setTimeout(resolve, 1000));

    // For this example we are using an env value, but this should be what is returned from the issue-token api.
    return import.meta.env.VITE_COURIER_JWT;
  };

  useEffect(() => {
    const signIn = async () => {
      const jwt = await generateCourierJwtOnYourServer();      
      courier.shared.signIn({
        userId: import.meta.env.VITE_COURIER_USER_ID,
        jwt,
      });
      
      // Add a local example
      // Note: Other messages can be added when you send messages via inbox to your users
      courier.toast.addMessage({
        messageId: '123',
        title: '🙌 Inbox is setup!',
        body: 'You can now send messages to your users via the inbox or use addMessage (like this!) to show a notification locally.',
      });
    };

    signIn();
  }, []);

  return (
    <CourierToast autoDismiss={true} />
  );
}

