var ff = require('ffef/FatFractal');
function sendNotification()
{
   notification = ff.getExtensionRequestData();
   message = notification.message;
   receiver = notification.to;
   
   //get guid of sender
   //sender = data.httpParamaters.sender;
   //receiver = data.httpParamaters.receiver;
   //console.log(" Data "+data);

   ff.sendPushNotifications(["7TuJG1fpPUbIFyxBHQiRy7"], messsage);
}



exports.sendNotification = sendNotification;