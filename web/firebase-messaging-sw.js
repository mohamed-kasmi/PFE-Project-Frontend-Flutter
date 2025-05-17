// firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js');

firebase.initializeApp({
    apiKey: "AIzaSyD_koN5WOFu38DAHRCm6tS_oN70E_nuMFw",
    authDomain: "pdcs-e2e3b.firebaseapp.com",
    projectId: "pdcs-e2e3b",
    storageBucket: "pdcs-e2e3b.firebasestorage.app",
    messagingSenderId: "624278702375",
    appId: "1:624278702375:web:95d31a6ab2d67978b3c102",
    measurementId: "G-WGY4C81S6F"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log("Background message received:", payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/icons/Icon-192.png"
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
