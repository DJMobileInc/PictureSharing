var ff = require('ffef/FatFractal');
function sendNotification()
{
   notification = ff.getExtensionRequestData();
  
   //content = notification.httpContent;
     
   message = notification.httpContent.message;
   receiver = notification.httpContent.to;
   
   //get guid of sender
   //sender = data.httpParamaters.sender;
   //receiver = data.httpParamaters.receiver;
   //console.log(" Data "+data);

   ff.sendPushNotifications([receiver], message);
}



exports.sendNotification = sendNotification;